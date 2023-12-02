#!/bin/bash
set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

apt update
apt upgrade

echo installing the must-have pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    git
    vim
    tmux
    curl
    wget
EOF
)

echo "alias ll='ls -lap'" >> ~/.bashrc
source ~/.bashrc
cp .tmux.conf ~/
cp .vimrc ~/

echo installing the nice-to-have pre-requisites
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6


curl -fsSL https://tailscale.com/install.sh | sh

echo "To copy key from your host, do this: ssh-copy-id -i ~/.ssh/filename.pub user@ip.add.ress"
