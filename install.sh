# pass FLAG
if [ -n "$1" ]; then
  FLAG=$1
fi

# target-sdk_install_pkg depends on target-sdk
make sdk_install_pkg ${FLAG} -s
if [ $? -ne 0 ]; then
  echo "[Error] make sdk_install_pkg"
  exit
fi
echo "[Success] make sdk_install_pkg"

# install sgx-sdk
echo "c" | sudo -S ./linux/installer/bin/sgx_linux_x64_sdk_*.bin <<EOF
no
/opt/intel/
EOF
if [ $? -ne 0 ]; then
  echo "[error] install sgx sdk"
  exit
fi
echo "[success] install sgx sdk"

# target-deb_local_repo depends on target-deb_psw_pkg which indirectly depends on target-psw
make deb_local_repo ${FLAG} -s
if [ $? -ne 0 ]; then
  echo "[Error] make deb_local_repo"
  exit
fi
echo "[Success] make deb_local_repo"

echo "c" | sudo -S apt update
echo "c" | sudo -S apt-get install libsgx-launch libsgx-urts libsgx-epid libsgx-quote-ex libsgx-dcap-ql -y
echo "c" | sudo -S apt-get install libsgx-launch-dbgsym libsgx-urts-dbgsym libsgx-epid-dbgsym libsgx-quote-ex-dbgsym libsgx-dcap-ql-dbgsym -y
# echo "c" | sudo -S apt-get install libsgx-launch-dev libsgx-urts-dev libsgx-epid-dev libsgx-quote-ex-dev libsgx-dcap-ql-dev -y
