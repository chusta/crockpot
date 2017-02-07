#!/bin/bash
# ansible prerequisites for ubuntu
[ $(id -u) -ne 0 ] && echo "run as root." && exit 1

PACKAGES=(
    aptitude
    openssh-server
    python
)

apt-get install -y "${PACKAGES[@]}"

SELF=$(who am i|cut -f1 -d" ")
SUDOERS_LINE="$SELF ALL=(ALL) NOPASSWD:ALL"
grep -q "$SUDOERS_LINE" /etc/sudoers || echo "$SUDOERS_LINE" >> /etc/sudoers
