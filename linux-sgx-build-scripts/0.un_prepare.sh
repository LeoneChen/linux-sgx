#!/bin/bash
set -e

sources_list_dir="/etc/apt/sources.list.d"

sudo rm -f /usr/local/bin/{as,ld,ld.gold,objdump}
sudo rm -f ${sources_list_dir}/intel-sgx.list

cd ..
make distclean -s
#comment to avoid user forget to git add recent modification
git clean -fd
git restore .
