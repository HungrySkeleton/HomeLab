#!/bin/bash

APPTAINER_RELEASE_VERSION=v1.1.9

# Ensure repositories are up-to-date
sudo apt-get update
# Install debian packages for dependencies
sudo apt-get install -y \
    build-essential \
    libseccomp-dev \
    pkg-config \
    uidmap \
    squashfs-tools \
    squashfuse \
    fuse2fs \
    fuse-overlayfs \
    fakeroot \
    cryptsetup \
    curl wget git

#Install GO
   export GOVERSION=1.18.4 OS=linux ARCH=amd64  # change this as you need

wget -O /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz \
  https://dl.google.com/go/go${GOVERSION}.${OS}-${ARCH}.tar.gz
sudo tar -C /usr/local -xzf /tmp/go${GOVERSION}.${OS}-${ARCH}.tar.gz
#Add GO to path environment Var
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

#Clone Repo
git clone https://github.com/apptainer/apptainer.git
cd apptainer

git checkout v1.1.9
./mconfig
cd ./builddir
make
sudo make install
apptainer --version

apt-get install -y autoconf automake libtool pkg-config libfuse-dev zlib1g-dev

#Download SquashFS from Source
SQUASHFUSEVERSION=0.1.105
SQUASHFUSEPRS="70 77 81"
curl -L -O https://github.com/vasi/squashfuse/archive/$SQUASHFUSEVERSION/squashfuse-$SQUASHFUSEVERSION.tar.gz
for PR in $SQUASHFUSEPRS; do
    curl -L -O https://github.com/vasi/squashfuse/pull/$PR.patch
done

#Compile and Install SquashFS
tar xzf squashfuse-$SQUASHFUSEVERSION.tar.gz
cd squashfuse-$SQUASHFUSEVERSION
for PR in $SQUASHFUSEPRS; do
    patch -p1 <../$PR.patch
done
./autogen.sh
FLAGS=-std=c99 ./configure --enable-multithreading
make squashfuse_ll
sudo cp squashfuse_ll /usr/local/libexec/apptainer/bin

export E2E_DOCKER_MIRROR=127.0.0.1:5001
export E2E_DOCKER_MIRROR_INSECURE=true
make -C builddir e2e-test
