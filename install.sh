#!/bin/bash
set -e
sudo pwd
FLAGS="$@"
make sdk_install_pkg ${FLAGS} -j$(nproc) -s
sudo apt-get install build-essential python -y
cd linux/installer/bin
sudo ./sgx_linux_x64_sdk_*.bin --prefix /opt/intel/
cd ../../..
# An error when make -j. (https://github.com/intel/linux-sgx/issues/755)
make deb_local_repo ${FLAGS} -j$(nproc) -s || make deb_local_repo ${FLAGS} -s
sudo apt-get update
sudo apt-get install libssl-dev libcurl4-openssl-dev libprotobuf-dev -y
sudo apt-get install libsgx-* -y
