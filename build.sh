#!/bin/sh
#
#
# Build z88dk on unix systems
#

set -e -u 		# -e: exit on error; -u: exit on undefined variable
				# -e can be overidden by -k option

do_clean=0
for arg in "$@"; do
  case "$arg" in
    -k) set +e					;;	# keep building ignoring errors
	-c) do_clean=1				;;	# clean before building
	*)  echo Usage: $0 [-k][-c]
		exit 1 					;;
  esac
done

if [ $do_clean = 1 ]; then
  make clean
  rm -rf bin
fi

mkdir -p bin
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

export INSTALL

$MAKE -e
$MAKE -C `pwd`/libsrc
$MAKE -C `pwd`/libsrc install
$MAKE -C `pwd`/libsrc/_DEVELOPMENT
