#!/bin/bash
set -e

echo "Starting C++ tools installation..."

PACKAGES=(
    binutils
    ccache
    clang lld
    clangd
    clang-format clang-tidy
    gcc g++
    lcov
    libc6-dev
    libc++-dev
    libc++abi-dev
    cmake make ninja-build
    mold
    gdb lldb heaptrack valgrind
    # Install the mimalloc allocator so we can get some memory use statistics with the following env:
    # LD_PRELOAD=/usr/lib/$(uname -m)-linux-gnu/libmimalloc.so;MIMALLOC_SHOW_STATS=1
    libmimalloc-dev
    # for profiling build
    google-perftools
    libgoogle-perftools-dev
)


# make apt write temp files as root to prevent a "permission denied"
# error in rootless/crun environments.
APT_OPTIONS="-o APT::Sandbox::User=root"

if [ -x "$(command -v apt-get)" ]
then
    apt-get update $APT_OPTIONS
    apt-get install $APT_OPTIONS --no-install-recommends -y "${PACKAGES[@]}"
else
    echo "ERROR: apt-get missing, nothing was installed"
    exit 1
fi

# use mold as default linker
update-alternatives --install /usr/bin/ld ld /usr/bin/x86_64-linux-gnu-ld 100
update-alternatives --install /usr/bin/ld ld /usr/bin/mold 50
update-alternatives --set ld /usr/bin/mold


# install conan globally
# RUN pip3 install --no-cache-dir conan


# determine the non-root user and home directory
USERNAME=${_REMOTE_USER:-${_CONTAINER_USER:-"vscode"}}

echo "Initializing dev-caches directory tree..."

mkdir -p /dev-caches/conan2
mkdir -p /dev-caches/ccache
mkdir -p /dev-caches/clangd

# Grant the non-root developer full ownership
chown -R ${USERNAME}:${USERNAME} /dev-caches

echo "Installation finished successfully!"
