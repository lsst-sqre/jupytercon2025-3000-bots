#!/usr/bin/env bash
# inspired by https://gitlab.com/olberger/docker-org-teaching-export

set -euo pipefail
set -x
export DEBIAN_FRONTEND=noninteractive

# We need contrib for the mscorefonts
sed -i -e "s/ main/ main contrib/g" /etc/apt/sources.list.d/debian.sources

apt-get update
apt-get -y dist-upgrade

# Set locale
apt-get -y install locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

apt-get -y install emacs-nox \
	texlive-latex-recommended texlive-plain-generic \
	texlive-fonts-recommended texlive-pstricks texlive-luatex \
	ttf-mscorefonts-installer \
	gpg xz-utils git sudo
apt-get clean
rm -rf /var/lib/apt/lists/*
