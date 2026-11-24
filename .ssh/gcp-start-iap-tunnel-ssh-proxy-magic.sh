#!/usr/bin/env bash
# ~/.ssh/gcp-start-iap-tunnel-ssh-proxy-magic.sh
# a script to be used as SSH ProxyCommand to allow fully functional SSH access to any Google Cloud Compute Engine VMs allowing IAP access
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2022-10-31
# License: MIT (see license)
# See also:
# - https://gist.github.com/netj/df4f9de1fefd254ab11979be7035b5d0/#readme
# - https://cloud.google.com/iap/docs/using-tcp-forwarding
# - https://man.openbsd.org/ssh_config (Host, ProxyCommand, and %n/%r/%p tokens)
# - https://gist.github.com/netj/d9006a823163d7662d8ff105c9a49e0e (aws-ssm-ssh-proxy-magic: the same idea for AWS)
#
# Instructions:
#
# 1. Copy this script to `~/.ssh/gcp-start-iap-tunnel-ssh-proxy-magic.sh`
#
# 2. Add the following lines to `~/.ssh/config`:
#
#   # Google Cloud Compute Engine full SSH via using `gcloud compute start-iap-tunnel` as ProxyCommand
#   Host *.gcloud *.c.*.internal
#       IdentityFile ~/.ssh/google_compute_engine
#       ProxyCommand bash ~/.ssh/gcp-start-iap-tunnel-ssh-proxy-magic.sh gce_instance=%n sshport=%p
#
# 3. Use Google Cloud's OS Login, or run `gcloud compute ssh INSTANCE --zone ZONE --project PROJECT --tunnel-through-iap` once ahead of time
#    to register the SSH key (~/.ssh/google_compute_engine) for your user name.
#
# 4. Enjoy SSH (esp. scp, rsync) for any instances allowed for IAP with no extra effort.
#
#
# Synopsis:
#
# $ ssh myhost.us-west1-a.my-gcp-project.gcloud
# $ scp myhost.us-west1-a.my-gcp-project.gcloud:remote/path local/path
# $ rsync -av myhost.us-west1-a.my-gcp-project.gcloud:remote/ local/
#
# Shorter host names fill in the rest:
#   myhost.us-west1-a.gcloud                   project from `gcloud config get project`
#   myhost.my-gcp-project.gcloud               zone looked up by instance name
#   myhost.gcloud                              both of the above
#
# GCE internal DNS names (e.g., pasted from VM logs or `hostname -f`) work too:
#   myhost.us-west1-a.c.my-gcp-project.internal
#   myhost.c.my-gcp-project.internal
#
##
set -eu

type gcloud >/dev/null

declare -- "$@"
: ${gce_instance:?} ${sshport:=22}

# parse host name formats (after dropping the .gcloud suffix):
#   $instance.$zone.c.$project.internal   $instance.c.$project.internal  (GCE internal DNS names, e.g., from VM logs)
#   $instance.$zone.$project   $instance.$zone   $instance.$project   $instance
# missing $project defaults to `gcloud config get project`, missing $zone is looked up from the instance name
gce_instance=${gce_instance%.gcloud}
zone= project=
if [[ $gce_instance == *.c.*.internal ]]; then
  # GCE internal DNS names: $instance.$zone.c.$project.internal or $instance.c.$project.internal
  project=${gce_instance#*.c.}; project=${project%.internal}
  gce_instance=${gce_instance%%.c.*}
  instance_name=${gce_instance%%.*}
  [[ $gce_instance != *.* ]] || zone=${gce_instance#*.}
else
  instance_name=${gce_instance%%.*}
  rest=${gce_instance#"$instance_name"}; rest=${rest#.}
  if [[ -n $rest ]]; then
    if [[ $rest == *.* ]]; then
      zone=${rest%%.*}
      project=${rest#*.}
    elif [[ $rest =~ ^[a-z]+-[a-z]+[0-9]+(-[a-z])?$ ]]; then
      zone=$rest  # looks like a zone name, e.g., us-west1-a
    else
      project=$rest
    fi
  fi
fi

# STDIN/STDOUT carry the SSH stream, so everything before the tunnel stays off them
{

if [[ -z $project ]]; then
  project=$(gcloud config get project 2>/dev/null) || project=
  [[ -n $project ]] || { echo "$0: no project given in the host name and none set in \`gcloud config get project\`" >&2; exit 1; }
fi

# ensure gcloud auth is good
gcloud --project="$project" compute os-login describe-profile >/dev/null || (
  set -x
  exec &>/dev/tty || true
  gcloud auth login --activate
)

# find the zone of the instance when omitted
if [[ -z $zone ]]; then
  zone=$(gcloud --project="$project" compute instances list --filter="name=$instance_name" --format='value(zone.basename())' --limit=1)
  [[ -n $zone ]] || { echo "$0: instance $instance_name not found in project $project" >&2; exit 1; }
fi

# ensure ssh key ~/.ssh/google_compute_engine is created (suppressing "Existing host keys found" noise)
(
gcloud --project="$project" compute ssh "$instance_name" --zone "$zone" --quiet --dry-run &>/dev/null
)

} </dev/null >&2

# hook up STDIO straight to the IAP tunnel
CLOUDSDK_PYTHON_SITEPACKAGES=1 \
exec gcloud compute start-iap-tunnel \
  --quiet --listen-on-stdin \
  --project="$project" "$instance_name" --zone="$zone" $sshport

