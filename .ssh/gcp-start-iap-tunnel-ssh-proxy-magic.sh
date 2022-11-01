#!/usr/bin/env bash
# ~/.ssh/gcp-start-iap-tunnel-ssh-proxy-magic.sh
# a script to be used as SSH ProxyCommand to allow fully functional SSH access to any Google Cloud Compute Engine VMs allowing IAP access
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2022-10-31
# See also:
# - https://cloud.google.com/iap/docs/using-tcp-forwarding
#
# Instructions:
#
# 1. Copy this script to ~/.ssh/gcp-start-iap-tunnel-ssh-proxy-magic.sh
#
# 2. Add the following lines to ~/.ssh/config:
#
#   # Google Cloud Compute Engine full SSH via using `gcloud compute start-iap-tunnel` as ProxyCommand
#   # (consider using this alongside `gcloud compute config-ssh`)
#   Host *.*-*-*.*
#       ProxyCommand sh ~/.ssh/gcp-start-iap-tunnel-ssh-proxy-magic.sh gce_instance=%n sshuser=%r sshport=%p
#
# 3. Use the `gcloud compute config-ssh --project=...` command to configure ssh host aliases for Compute Engine instances.
#
# 4. Enjoy SSH (esp. scp, rsync) for any instances allowed for SSM with no extra effort.
#
#
# Synopsis:
#
# $ scp myhost.us-west1-a.my-gcp-project:remote/path local/path
# $ rsync -av myhost.us-west1-a.my-gcp-project:remote/ local/
#
# $ ssh myhost.us-west1-a.my-gcp-project
#
##
set -eu

{

{
type gcloud
type nc
} >/dev/null

declare -- "$@"
: ${gce_instance:?} ${sshuser:=} ${sshport:=22}

iap_port=$(printf 22%03d $(($RANDOM % 1000)))

# parse the $instance.$zone.$project host alias format used by `gcloud compute config-ssh`
instance_name=${gce_instance%%.*}
project=${gce_instance##*.}
zone=${gce_instance#*.}; zone=${zone%.*}

# start the IAP tunnel (ensuring it is stopped at the end)
gcloud compute start-iap-tunnel --quiet >/dev/null --iap-tunnel-disable-connection-check \
  --project="$project" "$instance_name" --zone="$zone" $sshport --local-host-port=localhost:$iap_port &
trap "kill $!" EXIT

# wait until it comes up
until nc -z localhost $iap_port; do sleep 0.$RANDOM; done &>/dev/null

} </dev/null >&2

# then hook up the IAP port to STDIO
nc localhost $iap_port
