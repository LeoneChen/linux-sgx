#!/bin/bash
set -e

make SGX_MODE=HW SGX_DEBUG=0 SGX_PRERELEASE=1 DEBUG=0
# ~/SGXSan/Tool/GetLayout.sh pve_qe_common.o quoting_enclave.o se_sig_rl.o version.o quoting_enclave_t.o