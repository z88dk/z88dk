#!/bin/sh
#
#
# Build z88dk on unix systems
#

# Start from scratch
make clean

Z80_OZFILES=`pwd`/lib/
ZCCCFG=`pwd`/lib/config/
export Z80_OZFILES
export ZCCCFG

CC=gcc
CFLAGS="-g -O2"
CCOPT=-DUNIX
export CC
export CFLAGS
export CCOPT

make -e
make -C `pwd`/libsrc
make -C `pwd`/libsrc install

