#!/bin/sh
#
#
# Build z88dk on unix systems
#

set -e		# bail out if one of the make calls fails

# Start from scratch with argument "clean"
if [ "$1" = "clean" ]; then
  make clean
fi

rm -rf bin
mkdir bin
PATH=`pwd`/bin:$PATH
export PATH

Z80_OZFILES=`pwd`/lib/
ZCCCFG=`pwd`/lib/config/
export Z80_OZFILES
export ZCCCFG

CC=gcc
#CFLAGS="-g -O2"	# "make -e" below overrides CFLAGS in the called Makefiles by this one
					# causing problems building z80asm
CCOPT=-DUNIX
export CC
export CFLAGS
export CCOPT

MAKE="make"
INSTALL="install"

if [ "`uname -s`" = "SunOS" ]; then
   MAKE="gmake"
   INSTALL="ginstall"
fi

$MAKE -e
$MAKE -C `pwd`/libsrc
$MAKE -C `pwd`/libsrc install
$MAKE -C `pwd`/libsrc/_DEVELOPMENT
