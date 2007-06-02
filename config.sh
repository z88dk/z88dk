#!/bin/sh

# Some script hackery to allow global installs


destdir=$1


rm -f lib/config/*.cfg
for file in `ls lib/config/*.lnx`; do
   dest=`echo $file | sed 's/\.lnx/\.cfg/g'`
   sed "s?DESTDIR\/?$destdir?g" < $file > $dest
done

if [ x$DEFAULT != x ]; then
   cp lib/config/$DEFAULT.cfg lib/config/zcc.cfg
fi
