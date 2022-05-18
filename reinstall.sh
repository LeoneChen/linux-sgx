#!/bin/bash
set -e
./uninstall.sh
make clean -s
./install.sh "$@"
