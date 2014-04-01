#!/bin/sh

# Some script hackery to allow global installs

# Ignored now
destdir=$1

default=$2

if [ x$default != x ]; then
   cp lib/config/${default}.cfg lib/config/zcc.cfg
fi
