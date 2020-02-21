#!/bin/bash
#
#
# Assumes that the following environment variables are defined:
#
#   - WHEEL_URL           - URL of server to rsync wheels to (username@host)
#   - SSH_SERVER_HOSTKEYS - List of trusted SSH hosts (should just contain the
#                           upload url)

# Wheel and conda private key files must be passed in as the sole two arguments
# to this script.
wheelkey=$1
wheelkeyname=`basename $wheelkey`

eval "$(ssh-agent -s)"
mkdir -p $HOME/.ssh
cp $wheelkey $HOME/.ssh/
chmod -R go-rwx $HOME/.ssh
ssh-add $HOME/.ssh/$wheelkeyname

echo "$SSH_SERVER_HOSTKEYS" > $HOME/.ssh/known_hosts
touch $HOME/.ssh/config;
echo "Host uploadhost"                           >> $HOME/.ssh/config;
echo "    HostName ${WHEEL_URL##*@}"             >> $HOME/.ssh/config;
echo "    User ${WHEEL_URL%@*}"                  >> $HOME/.ssh/config;
echo "    IdentityFile $HOME/.ssh/$wheelkeyname" >> $HOME/.ssh/config;
