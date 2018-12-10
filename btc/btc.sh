#!/bin/sh
echo "127.0.0.1 `cat /etc/hostname`" | tee -a /etc/hosts

cho "start to mount data block"
lsblk
#first
mkfs -t ext4 /dev/xvdg
cp /etc/fstab /etc/fstab.orig
echo '/dev/xvdg       /data   ext4    defaults,nofail       0  2' | tee -a /etc/fstab
mkdir /data
mount -a
cd /data

echo "install nodejs"
apt-get update && apt-get install curl 
curl -sL https://deb.nodesource.com/setup_8.x -o ~/nodesource_setup.sh
bash ~/nodesource_setup.sh
apt-get install nodejs

echo "install build tools"
apt-get install libtool pkg-config build-essential autoconf automake 
npm install -g node-gyp

add-apt-repository ppa:chris-lea/zeromq
add-apt-repository ppa:chris-lea/libpgm
apt-get update
apt-get install libzmq3-dev

echo "install bitcore"
npm install -g --unsafe-perm=true bitcore@latest

echo "create project"
bitcore create mynode
cd mynode
bitcore install insight-api
bitcore install insight-ui

echo "bitcore start"
bitcore start  
