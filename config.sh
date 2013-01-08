#!/bin/sh

# Some script hackery to allow global installs

destdir=$1
default=$2

# Convert absolute paths to Windows notation in MinGW 
# pwd returns /c/xxx, but MinGW needs c:/xxx in the config files
if uname | grep -q ^MINGW32 ; then
   destdir=`echo $1 | sed 's?^/\([a-z]\)/?\1:/?'`
fi

rm -f lib/config/*.cfg
for file in `ls lib/config/*.lnx`; do
   dest=`echo $file | sed 's/\.lnx/\.cfg/g'`
   sed "s?DESTDIR\/?$destdir?g" < $file > $dest
done

if [ x$default != x ]; then
   cp lib/config/${default}.cfg lib/config/zcc.cfg
fi
