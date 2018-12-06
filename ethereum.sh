#!/bin/sh
set -e

echo "127.0.0.1 `cat /etc/hostname`" | sudo tee -a /etc/hosts

echo "start to mount data block"
lsblk
#first
sudo mkfs -t ext4 /dev/xvdg
sudo cp /etc/fstab /etc/fstab.orig
echo '/dev/xvdg       /data   ext4    defaults,nofail       0  2' |sudo tee -a /etc/fstab
sudo mkdir /data
sudo mount -a
cd /data

echo "install build tools"
# sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get update
sudo apt-get install -y build-essential unzip tar curl wget
sudo curl -O https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.11.2.linux-amd64.tar.gz
sudo rm -rf go1.11.2.linux-amd64.tar.gz

sudo mkdir go/ && sudo mkdir go/src/
sudo chmod 777 /etc/profile
sudo echo "export GOPATH=/data/go" >> /etc/profile
sudo echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
source /etc/profile


#build
echo "Start to download"
cd go/src
sudo wget https://github.com/ethereum/go-ethereum/archive/master.zip
sudo unzip master.zip
sudo rm -rf master.zip
sudo cp -r  go-ethereum-master/ go-ethereum
sudo rm -rf go-ethereum-master/
cd go-ethereum/

echo "Start to compile"
sudo env "PATH=$PATH" make geth
echo "Start Ethereum point"
sudo mkdir ../data && sudo mkdir ../log && sudo touch ../log/eth.log
sudo chmod 777 ../data && sudo chmod 777 ../log/eth.log
# You must set rpcuser and rpcpassword to secure the JSON-RPC api
# Listen for JSON-RPC connections on <port> (default: 30303)

## For tenet rpc port is 3001
sudo ./build/bin/geth --testnet --syncmode "fast" --rpc --cache=1024 --rpcaddr 127.0.0.1 --rpcport 3001 --rpcapi "eth,net,web3"  --datadir "../data" console 2>>../log/eth.log

## For mainnet rpc port is 3001
# sudo ./build/bin/geth --syncmode "fast" --rpc --cache=1024 --rpcaddr 127.0.0.1 --rpcport 3001 --rpcapi "eth,net,web3"  --datadir "../data" console 2>>../log/eth.log
