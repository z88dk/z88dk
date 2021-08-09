#!/bin/sh
#
#
# Build z88dk on unix systems
#

show_help_and_exit()
{

  if [ -n $1 ]; then rc=$1; else rc=0; fi

  echo ""
  echo "Usage: $0 [-b][-c][-C][-e][-h][-k][-l][-p][-t]"
  echo ""
  echo "  -b    Don't build binaries"
  echo "  -c    Clean build environment"
  echo "  -C    Clean build environment and binaries (including bin/*)"
  echo "        Chosing this option makes a manual rebuild of zsdcc and"
  echo "        szdcpp necessary in the win32 environment"
  echo "  -e    Build examples"
  echo "  -h    This help information"
  echo "  -k    Keep building ignoring errors"
  echo "  -l    Don't build libraries"
  echo "  -p    TARGET Build specified targets"
  echo "  -i    PATH Final installation directory"
  echo "  -t    Run tests"
  echo ""
  echo "Default is to build binaries and libraries"
  echo ""

  exit $rc
}


set -e      # -e: exit on error; -u: exit on undefined variable
            # -e can be overidden by -k option

case `uname -s` in                      # Insert default values for MAKE and INSTALL following used OS
  SunOS)
    MAKE="gmake"
    INSTALL="ginstall"
    export INSTALL
    ;;
  OpenBSD|NetBSD|FreeBSD)
    MAKE="gmake"
    INSTALL="install"
    export INSTALL
    ;;
  *)
    MAKE="make"
    INSTALL="install"
    export INSTALL
    ;;
esac

do_build=1                              # Set initial (default)  values (build binaries and libraries)
do_clean=0
do_clean_bin=0
do_examples=0
do_libbuild=1
do_tests=0

DESTDIR=/usr/local

builddir=`dirname $0`
ZCCCFG=$builddir/lib/config
PATH=$builddir/bin:$PATH
export ZCCCFG
export PATH


while getopts "bcCehkltp:i:" arg; do       # Handle all given arguments
  case "$arg" in
    b)     do_build=0              ;;   # Don't build
    c)     do_clean=1              ;;   # clean except bin/*
    C)     do_clean_bin=1          ;;   # Clean including bin/*
    e)     do_examples=1           ;;   # Build examples as well
    k)     set +e                  ;;   # keep building ignoring errors
    l)     do_libbuild=0           ;;   # Don't build libraries
    p)     TARGETS=$OPTARG  ;;
    i)     DESTDIR=$OPTARG  ;;
    t)     do_tests=1              ;;   # Run tests as well
    h | *) show_help_and_exit 0    ;;   # Show help on demand
  esac
done

                                        # If there will be no action at all with the given parameters, then show help and exit with error
if [ $do_clean     != 1 ]          \
&& [ $do_clean_bin != 1 ]          \
&& [ $do_build     != 1 ]          \
&& [ $do_libbuild  != 1 ]          \
&& [ $do_tests     != 1 ]          \
&& [ $do_examples  != 1 ]; then
  show_help_and_exit 1
fi

if [ $do_clean = 1 -o $do_clean_bin = 1 ]; then              # Dont remove bin, as zsdcc and szdcpp must be built by hand in win32
  $MAKE clean
fi


if [ $do_clean_bin = 1 ]; then          # Remove bin => zsdcc and zdcpp must be built again by hand in win32
  echo "rm -rf bin"
  rm -rf bin
fi

                                        # If there was only cleaning to do then don't change paths, global variables, ...
if [ $do_build    != 1 ]           \
&& [ $do_libbuild != 1 ]           \
&& [ $do_tests    != 1 ]           \
&& [ $do_examples != 1 ]; then
  exit 0
fi


if [ -z "$CC" ]; then                   # Insert default value for CC if CC is empty
  CC="gcc"
  export CC
fi


if [ -z "$CFLAGS" ]; then               # Insert default value for CFLAGS if CFLAGS is empty
  CFLAGS="-g -O2"
  export CFLAGS
fi


path=`pwd`/bin                          # Add bin directory to path if it's not already there
mkdir -p $path                          # Guarantee that the directory exists
if [ $PATH != *$path* ]; then
  PATH=$path:$PATH
  export PATH
fi


ZCCCFG=`pwd`/lib/config/                # Set ZCCCFG to the lib config directory
mkdir -p $ZCCCFG                        # Guarantee that the directory exists
export ZCCCFG


if [ $do_build = 1 ]; then              # Build binaries or not...
  $MAKE DESTDIR=$DESTDIR
fi


if [ $do_libbuild = 1 ]; then           # Build libraries or not...
  if [ $TARGETS ]; then
	  MAKEARG="TARGETS=$TARGETS"
  else
	  MAKEARG=""
  fi
  $MAKE -C libsrc $MAKEARG
  $MAKE -C libsrc install
  $MAKE -C libsrc/_DEVELOPMENT $TARGETS
  $MAKE -C include/_DEVELOPMENT
fi


if [ $do_tests = 1 ]; then              # Build tests or not...
  $MAKE -C testsuite
  $MAKE -C test
fi


if [ $do_examples = 1 ]; then           # Build examples or not...
  $MAKE -C examples
fi
