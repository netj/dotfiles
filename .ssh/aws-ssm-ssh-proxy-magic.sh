#!/usr/bin/env bash
# ~/.ssh/aws-ssm-ssh-proxy-magic.sh -- a nifty script for ssh'ing into any AWS SSM-enabled EC2 instance with no extra manual setup
#
# Author: Jaeho Shin <netj@sparcs.org>
# Created: 2021-02-01
# See also:
# - https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html
# - https://gist.github.com/d9006a823163d7662d8ff105c9a49e0e
#
# 1. Copy this script to ~/.ssh/aws-ssm-ssh-proxy-magic.sh
#
# 2. Add the following lines to ~/.ssh/config:
#
#     # SSH over AWS Session Manager
#     Host i-* mi-*  *.ec2.aws
#         #ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
#         ProxyCommand sh ~/.ssh/aws-ssm-ssh-proxy-magic.sh ec2instanceid=%h sshuser=%r sshport=%p
#     # share connection across sessions until idle for 1h
#     Host i-* mi-*  *.ec2.aws
#         ControlMaster auto
#         ControlPath ~/.ssh/master-%r@%h:%p
#         ControlPersist 3600
#
#     ###################
#     # instances with aliases
#
#     # XXX just an example giving an alias to some instance
#     Host i-02573cafcfEXAMPLE ourinstance.ec2.aws ours.ec2.aws
#         HostName i-02573cafcfEXAMPLE
#         User mylogin
#
#     ###################
#     # trust instances with alias
#     Host *.ec2.aws
#         ForwardAgent yes
#     # default to ec2-user
#     Host i-* mi-*
#         User ec2-user
#
# 3. Enjoy SSH (esp. scp, rsync) for any instances allowed for SSM with no extra effort.
#
# $ brew install --cask session-manager-plugin  # you may need this on your macOS
#
# $ scp ubuntu@i-02573cafcfEXAMPLE:remote/path local/path
# $ rsync -av ec2-user@i-02573cafcfEXAMPLE:remote/ local/
#
# $ ssh ubuntu@i-02573cafcfEXAMPLE
# $ ssh ec2-user@i-02573cafcfEXAMPLE
# $ ssh i-02573cafcfEXAMPLE  # these assume you have the ssh key for the instance
#
# $ ssh mylogin@i-02573cafcfEXAMPLE  # creates the user `mylogin` on the EC2 instance automatically with SSM
# $ ssh mylogin@ourinstance.ec2.aws  # using an alias can be much easier
# $ ssh ours.ec2.aws                 # using the configured user (or same login as local) with an even shorter alias
#
##
set -eu

type aws
type jq
type awk
type ssh-add

test $# -eq 0 || export -- "$@"
: ${ec2instanceid:?} ${sshuser:?} ${sshport:=22}

set -x

case $sshuser in
    ubuntu|ec2-user)
        # TODO use aws ec2-instance-connect send-ssh-public-key --ssh-public-key file://<(ssh-add -L)  # but only when it is an RSA key supported by awscli
        ;;
    *)  # create user on the instance
        aws ssm send-command --cli-input-json "$(
            u="$sshuser" \
            i="$ec2instanceid" \
            k=$(ssh-add -L | awk '{print $1, $2}') \
            jq -n '{DocumentName:"AWS-RunShellScript",InstanceIds:[env.i],Parameters:{commands:
                [ @sh "set -eux"
                , @sh "id \(env.u) || sudo useradd --create-home --no-user-group --gid users --groups admin,sudo --shell /bin/bash \(env.u)"
                , @sh "sudo test -e /etc/sudoers.d/nopassword4admin || echo \"%admin ALL=(ALL) NOPASSWD:ALL\" | sudo tee /etc/sudoers.d/nopassword4admin"
                , @sh "eval sudo -u \(env.u) mkdir -p ~\(env.u)/.ssh"
                , @sh "eval cd ~\(env.u)/.ssh"
                , @sh "k=\(env.k)"
                , @sh "grep -qxF \"$k\" authorized_keys || echo \"$k\" | sudo -u \(env.u) tee -a authorized_keys"
                ] | [join("\n")]}}')"
        # XXX to debug the `aws ssm send-command`, find the "CommandId" from `ssh -v`, and use: aws ssm get-command-invocation --instance-id ... --command-id ...
esac

aws ssm start-session --target "$ec2instanceid" --document-name AWS-StartSSHSession --parameters "portNumber=$sshport"
