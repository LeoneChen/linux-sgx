#!/bin/bash
set -e
linux_sgx_src_dir="/home/leone/文档/linux-sgx"
sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python libssl-dev git cmake perl -y
sudo apt-get install libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake reprepro unzip -y
make preparation
current_distr="ubuntu18.04"
sudo cp external/toolset/${current_distr}/* /usr/local/bin
sources_list_dir="/etc/apt/sources.list.d"
sudo mkdir -p ${sources_list_dir}
intel_sgx_list=${sources_list_dir}/intel-sgx.list
if [ -f ${intel_sgx_list} ]
then
  echo "[Already Exist] \"${intel_sgx_list}\""
else
  sudo touch ${intel_sgx_list}
  sudo sh -c "echo \"deb [trusted=yes arch=amd64] file:${linux_sgx_src_dir}/linux/installer/deb/sgx_debian_local_repo bionic main\" >> ${intel_sgx_list}"
  echo "[Successful Add] \"${intel_sgx_list}\""
fi
