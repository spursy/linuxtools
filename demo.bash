#!/bin/sh
set -e

echo "127.0.0.1 `cat /etc/hostname`" | sudo tee -a /etc/hosts
sudo apt-get update && sudo apt-get -y upgrade;
sudo apt-get -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 zip unzip
sudo apt-get -y install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev

## optimize the system
# ulimit update
echo -e "* soft nofile 65535\n* hard nofile 65535\n" | tee -a /etc/security/limits.conf

#build
echo "Start to download"
wget https://codeload.github.com/WaykiChain/WaykiChain/zip/master
cp master master.zip
rm -rf master
unzip master.zip
rm -rf master.zip
cp -r  WaykiChain-master/ WaykiChain
rm -rf WaykiChain-master
cd WaykiChain/linux_shell/
sudo chmod +x *.sh
echo "start to compile"
sudo ./linux.sh
cd ../
echo "autogen-coin-man.sh coin"
sudo ./autogen-coin-man.sh coin
cd ./share
sudo chmod 777 genbuild.sh
cd ../
sudo make -j4
sudo make install
cd src

echo "start to mount data block"
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
lsblk
#first
sudo mkfs -t ext4 /dev/xvdg
sudo cp /etc/fstab /etc/fstab.orig
echo '/dev/xvdg       /data   ext4    defaults,nofail       0  2' |sudo tee -a /etc/fstab
sudo mkdir /data
sudo mount -a
sudo chown -R ubuntu:ubuntu /data
mkdir -p /data/.waykicoin
echo '
# You must set rpcuser and rpcpassword to secure the JSON-RPC api
# Please make rpcpassword to something secure, `5gKAgrJv8CQr2CGUhjVbBFLSj29HnE6YGXvfykHJzS3k` for example.
# Listen for JSON-RPC connections on <port> (default: 8332 or testnet: 18332)
rpcuser=bcd
rpcpassword=Hx2Wp4mFThPq
rpcport=6968
rpcallowip=*.*.*.*
blockminsize=1000
zapwallettxes=0
debug=INFO
printtoconsole=0
logtimestamps=1
logprintfofile=1
logprintfileline=1
server=1
listen=1
uiport=4555
isdbtraversal=1
disablesafemode=1
gen=1
genproclimit=1000000
' | tee -a /data/.waykicoin/WaykiChain.conf