#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive

apt update
apt full-upgrade -y
apt install -y \
    bzip2 \
    ca-certificates \
    curl \
    locales \
    sudo \
    xz-utils

# git is to help use of the image in ci / github-action (at least to use actions/checkout)
apt install -y git

apt autoremove --purge -y
rm -rf /var/lib/apt/lists/*

localedef -f UTF-8 -i en_US -A /usr/share/locale/locale.alias -c en_US.UTF-8

USER_NAME=ci
USER_HOME=/home/${USER_NAME}
useradd \
    --home ${USER_HOME} \
    --create-home \
    --password "!" \
    ${USER_NAME}
usermod -aG sudo ${USER_NAME}
mkdir -m 0755 /nix && chown ci /nix
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
