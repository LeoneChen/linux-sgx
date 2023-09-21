#!/bin/bash
set -e

make SGX_MODE=HW SGX_DEBUG=0 SGX_PRERELEASE=1 DEBUG=0
# ~/SGXSan/Tool/GetLayout.sh pce.o pce_helper.o version.o pce_t.o