#!/bin/bash
ARCH=$1

echo "Download Debs for $ARCH"
cat /etc/apt/sources.list|sed -e 's/^deb /deb-src /' | sort -u >> /etc/apt/sources.list
apt-get -y update 
apt-get -y upgrade

case $ARCH in
	amd64)
        apt-get -y install debian-archive-keyring gnupg1
        /bin/echo -ne "deb http://deb.debian.org/debian experimental main\ndeb-src http://deb.debian.org/debian experimental main\n"> /etc/apt/sources.list.d/experimental.list
        /bin/echo -ne "Package: ghc*\nPin: release a=experimental\nPin-Priority: 600" > /etc/apt/preferences.d/ghc.pref
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
        ;;
    riscv64|arm64)
        apt-get -y install debian-ports-archive-keyring
        /bin/echo -ne "deb http://ftp.ports.debian.org/debian-ports experimental main\ndeb-src http://ftp.ports.debian.org/debian-ports experimental main\n"> /etc/apt/sources.list.d/experimental.list
        /bin/echo -ne "Package: ghc*\nPin: release a=experimental\nPin-Priority: 600" > /etc/apt/preferences.d/ghc.pref
	    ;;
esac

apt-get -y update
apt-get -y install --no-install-recommends apt-utils bash curl wget ca-certificates automake build-essential pkg-config \
libffi7 libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool \
autoconf libnuma1 libnuma-dev ghc llvm clang llvm-12 llvm-12-dev clang-12 libclang-12-dev gdb