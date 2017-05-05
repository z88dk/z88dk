#!/bin/sh
#
#
# Build z88dk on unix systems
#

set -e  		# -e: exit on error; -u: exit on undefined variable
				# -e can be overidden by -k option

do_clean=0
do_tests=0
do_build=1
do_libbuild=1
for arg in "$@"; do
  case "$arg" in
    -k) set +e					;;	# keep building ignoring errors
    -c) do_clean=1				;;	# clean before building
    -t) do_tests=1				;;	# Run tests as well
    -nb) do_build=0				;;	# Don't build
    -nl) do_libbuild=0				;;	# Don't build libraries
     *) 
	echo "Usage: $0 [-k][-c][-t][-nb][-nl]"
	echo
	echo "-k\tKeep building ignoring errors"
	echo "-c\tClean before building"
	echo "-t\tRun tests"
	echo "-nb\tDon't build binaries"
	echo "-nl\tDon't build libraries"
	echo ""
	echo "Default is to build binaries and libraries"
	exit 1 
	;;
  esac
done

if [ $do_clean = 1 ]; then
  make clean
  rm -rf bin/*
fi

mkdir -p bin
PATH=`pwd`/bin:$PATH
export PATH

ZCCCFG=`pwd`/lib/config/
export ZCCCFG


if [ -z "$CFLAGS" ]; then
   CFLAGS="-g -O2"	
fi

export CC
export CFLAGS

case `uname -s` in
    SunOS)
        MAKE="gmake"
        INSTALL="ginstall"
        ;;
    OpenBSD|NetBSD|FreeBSD)
        MAKE="gmake"
        INSTALL="install"
        ;;
    *)
        MAKE="make"
        INSTALL="install"
        ;;
esac

export INSTALL


if [ $do_build = 1 ]; then
    $MAKE 
fi


if [ $do_libbuild = 1 ]; then
    $MAKE -C libsrc 
    $MAKE -C libsrc install 
    $MAKE -C libsrc/_DEVELOPMENT 
fi
if [ $do_tests = 1 ]; then
    $MAKE -C testsuite 
    $MAKE -C test 
fi

