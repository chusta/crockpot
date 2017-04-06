#!/bin/bash
# ansible prerequisites for ubuntu
[ $(id -u) -ne 0 ] && echo "run as root." && exit 1

SYSTEM_PKGS=(
    aptitude
    python
    python-dev
)

PYTHON_PKGS=(
    ansible
)

apt-get install -y "${SYSTEM_PKGS[@]}"
pip install -U "${PYTHON_PKGS[@]}"
