#!/bin/sh
echo "127.0.0.1 `cat /etc/hostname`" | tee -a /etc/hosts
apt-get update &&  apt-get -y upgrade;
apt-get install -y software-properties-common
add-apt-repository -y ppa:ethereum/ethereum
apt-get update
apt-get install -y ethereum


lsblk

mkfs -t ext4 /dev/xvdg

echo "backup fstab"
cp /etc/fstab /etc/fstab.orig

cat /etc/fstab
echo '/dev/xvdg       /data   ext4    defaults,nofail       0  2' | tee -a /etc/fstab
mkdir /data
mount /dev/xvdg /data
mount -a
mkdir -p /data/.ethereum
chown -R ubuntu:ubuntu /data


echo "add geth.service"
echo '
[Unit]
Description=Ethereum go client

[Service]
Type=simple
ExecStart=/usr/bin/geth --testnet --syncmode "fast" --rpc --cache=1024 --rpcaddr 127.0.0.1 --rpcport 3001 --rpcapi "eth,net,web3"  --datadir "/data/.ethereum"

Restart=always

[Install]
WantedBy=default.target
' | tee -a /etc/systemd/system/geth.service

systemctl enable geth.service