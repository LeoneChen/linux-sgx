#!/bin/bash
set -e

make SGX_MODE=HW SGX_DEBUG=0 SGX_PRERELEASE=1 DEBUG=0
# ~/SGXSan/Tool/GetLayout.sh endpoint_selection.o helper.o pek_pub_key.o provision_enclave.o provision_msg1.o provision_msg2.o provision_msg3.o provision_msg4.o pve_qe_common.o pve_rng.o pve_verify_signature.o version.o provision_enclave_t.o