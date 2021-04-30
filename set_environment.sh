#!/bin/sh

export PATH=`pwd`/bin:$PATH

CFG=`pwd`/lib/config/
case "`uname -s`" in
    CYGWIN*)    export ZCCCFG=`cygpath -m $CFG`;;
    *)          export ZCCCFG=$CFG ;;
esac
