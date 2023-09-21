#!/bin/bash
set -e

make SGX_MODE=HW SGX_DEBUG=0 SGX_PRERELEASE=1 DEBUG=0
# ~/SGXSan/Tool/GetLayout.sh launch_enclave_t.o launch_enclave.o version.o
