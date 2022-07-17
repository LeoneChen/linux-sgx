#!/bin/bash
set -e

current_distr="ubuntu20.04"
pwd=$(pwd)

sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python-is-python3 libssl-dev git cmake perl -y
sudo apt-get install libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake reprepro unzip -y

cd ..
make preparation

sudo cp external/toolset/${current_distr}/* /usr/local/bin

cd ${pwd}
./set_apt_source.sh
