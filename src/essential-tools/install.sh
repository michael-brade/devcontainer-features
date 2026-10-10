#!/bin/sh
set -e

echo "Installing essential tools..."

# make apt write temp files as root to prevent a "permission denied"
# error in rootless/crun environments.
APT_OPTIONS="-o APT::Sandbox::User=root"

if [ -x "$(command -v apt-get)" ]; then
    apt-get update $APT_OPTIONS
    apt-get install $APT_OPTIONS --no-install-recommends -y \
      locales \
      git \
      htop \
      less source-highlight \
      neovim \
      rsync

    locale-gen en_US.UTF-8
else
    echo "ERROR: apt-get missing, nothing was installed"
    exit 1
fi

echo "Installation successful!"
