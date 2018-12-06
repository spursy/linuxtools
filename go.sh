#!/bin/sh
set -e

echo "127.0.0.1 `cat /etc/hostname`" |   tee -a /etc/hosts

echo "install build tools"
  apt-get update 
  apt-get install -y build-essential unzip tar curl
  curl -O https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.11.2.linux-amd64.tar.gz
  rm -rf go1.11.2.linux-amd64.tar.gz

  mkdir go/ &&   mkdir go/src/
  echo "export GOPATH=/data/go" >> /etc/profile
  echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
source /etc/profile

go version