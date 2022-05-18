#!/bin/bash
set -e
sudo rm -f /usr/local/bin/{ar,as,ld,objcopy,objdump,ranlib}
sudo rm -f /etc/apt/sources.list.d/intel-sgx.list
make distclean -s
git clean -fd
git restore .
