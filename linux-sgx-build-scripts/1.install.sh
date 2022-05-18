#!/bin/bash
set -e

# install sgxsdk
sudo ../linux/installer/bin/sgx_linux_x64_sdk_*.bin <<EOF
no
/opt/intel/
EOF

# install sgxpsw
sudo apt-get update
sudo apt-get install libsgx-* -y