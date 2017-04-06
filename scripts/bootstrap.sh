#!/bin/bash
# ansible prerequisites for ubuntu
[ $(id -u) -ne 0 ] && echo "run as root." && exit 1

PACKAGES=(
    aptitude
    openssh-server
    python
)

apt-get install -y "${PACKAGES[@]}"
