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

ZCCCFG=`pwd`/lib/config/
export ZCCCFG

CFLAGS="-g -O2"	

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

$MAKE 
$MAKE -C `pwd`/libsrc
$MAKE -C `pwd`/libsrc install
$MAKE -C `pwd`/libsrc/_DEVELOPMENT
$MAKE -C test
