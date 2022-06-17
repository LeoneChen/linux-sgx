#!/bin/bash
set -e

# install sgxsdk
sudo ../linux/installer/bin/sgx_linux_x64_sdk_*.bin --prefix /opt/intel/

# install sgxpsw
sudo apt-get update
sudo apt-get install libsgx-* -y