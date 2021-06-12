sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python2 python-is-python3 libssl-dev git cmake perl libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake reprepro unzip build-essential libssl-dev libcurl4-openssl-dev libprotobuf-dev -y

make preparation
sudo cp external/toolset/ubuntu20.04/{as,ld,ld.gold,objdump} /usr/local/bin

list_dir=/etc/apt/sources.list.d
psw_list=$list_dir/intel-sgx-psw.list

if [ ! -d "$list_dir" ]; then
  mkdir "$list_dir"
fi

if [ ! -f "$psw_list" ]; then
  sudo touch "$psw_list"
  sudo sh -c "echo \"deb [trusted=yes arch=amd64] file:/home/leone/文档/linux-sgx/linux/installer/deb/sgx_debian_local_repo focal main\" >> $psw_list"
fi

echo "Finish adding apt source"
