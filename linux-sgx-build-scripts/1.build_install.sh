#!/bin/bash
set -e

sudo pwd
FLAGS="$@"
cd ..

# build sgxsdk
# rule "sdk_install_pkg" depends on rule "sdk", so skip rule "sdk"
make sdk_install_pkg -s -j$(nproc) --output-sync=recurse ${FLAGS}

sudo apt-get install build-essential python -y

# install sgxsdk
sudo ./linux/installer/bin/sgx_linux_x64_sdk_*.bin <<EOF
no
/opt/intel/
EOF

# build sgxpsw, which relies on installed sgxsdk
# target "deb_local_repo" depends on target "deb_psw_pkg" which indirectly depends on target "psw"
# there is an error when make -j. (https://github.com/intel/linux-sgx/issues/755)
make deb_local_repo -s -j$(nproc) --output-sync=recurse ${FLAGS} || make deb_local_repo -s ${FLAGS}

# install sgxpsw
sudo apt-get update
sudo apt-get install libssl-dev libcurl4-openssl-dev libprotobuf-dev -y
sudo apt-get install libsgx-* -y
