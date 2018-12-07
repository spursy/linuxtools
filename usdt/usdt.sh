#!/bin/sh
set -e

echo "127.0.0.1 `cat /etc/hostname`" |  tee -a /etc/hosts

echo "start to mount data block"
lsblk
#first
mkfs -t ext4 /dev/xvdg
cp /etc/fstab /etc/fstab.orig
echo '/dev/xvdg       /data   ext4    defaults,nofail       0  2' |  tee -a /etc/fstab
mkdir /data
mount -a
cd /data

#first
echo "install build tools"
apt-get update && apt-get install -y
 build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev unzip wget

echo "install BerkeleyDB"
apt-get install software-properties-common && add-apt-repository ppa:bitcoin/bitcoin
apt-get update && apt-get install libdb4.8-dev libdb4.8++-dev

#second
mkdir usdt && cd usdt
echo "get omnicore origin code"
wget https://github.com/OmniLayer/omnicore/archive/master.zip
unzip master.zip
rm -rf master.zip

cp -r omnicore-master/  omnicore/
rm -rf omnicore-master/
cd omnicore/

#third
echo "build"
./autogen.sh
./configure
make

# You must set rpcuser and rpcpassword to secure the JSON-RPC api
# Listen for JSON-RPC connections on <port> (default: 8333)

#fourth
mkdir ../usdtdata
mkdir ../config && touch ../config/bitcoin.conf
chmod 777 ../usdtdata && chmod 777 ../config/bitcoin.conf

echo "add configuration"
echo 'server=1  
txindex=1 
rpcuser=binode
rpcpassword=shujufengkong
rpcallowip=127.0.0.1 
rpcport=8332
paytxfee=0.00001
minrelaytxfee=0.00001
datacarriersize=80
logtimestamps=1
omnidebug=tally  
omnidebug=packets
omnidebug=pending' | tee -a ../config/bitcoin.conf

#latest
echo "start"

#for testnet
./src/omnicored -testnet  --datadir=../usdtdata --conf=../config/bitcoin.conf

#for mainnet
# ./src/omnicored  --datadir=../usdtdata --conf=../config/bitcoin.conf