#!/bin/sh

# Some script hackery to allow global installs


destdir=$1

DEFAULT=$2



rm -f $destdir/lib/config/*.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/abc80.lnx > $destdir/lib/config/abc80.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/aceansi.lnx > $destdir/lib/config/aceansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/aquarius.lnx > $destdir/lib/config/aquarius.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/aquansi.lnx > $destdir/lib/config/aquansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/c128ansi.lnx > $destdir/lib/config/c128ansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/cpm.lnx > $destdir/lib/config/cpm.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/cpc.lnx > $destdir/lib/config/cpc.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/m5.lnx > $destdir/lib/config/m5.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/msx.lnx > $destdir/lib/config/msx.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/mz.lnx > $destdir/lib/config/mz.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/mzansi.lnx > $destdir/lib/config/mzansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/nc.lnx > $destdir/lib/config/nc.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/pps.lnx > $destdir/lib/config/pps.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ppsansi.lnx > $destdir/lib/config/ppsansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/rex.lnx > $destdir/lib/config/rex.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/rexlib.lnx > $destdir/lib/config/rexlib.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/sam.lnx > $destdir/lib/config/sam.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/svi.lnx > $destdir/lib/config/svi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti82.lnx > $destdir/lib/config/ti82.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti82ansi.lnx > $destdir/lib/config/ti82ansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti83.lnx > $destdir/lib/config/ti83.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti83ansi.lnx > $destdir/lib/config/ti83ansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti8x.lnx > $destdir/lib/config/ti8x.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti8xansi.lnx > $destdir/lib/config/ti8xansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti85.lnx > $destdir/lib/config/ti85.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti85ansi.lnx > $destdir/lib/config/ti85ansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti86.lnx > $destdir/lib/config/ti86.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/ti86ansi.lnx > $destdir/lib/config/ti86ansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/vz.lnx > $destdir/lib/config/vz.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/vzansi.lnx > $destdir/lib/config/vzansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/z88.lnx > $destdir/lib/config/z88.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/z88ansi.lnx > $destdir/lib/config/z88ansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/z88net.lnx > $destdir/lib/config/z88net.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/zx81.lnx > $destdir/lib/config/zx81.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/zx81ansi.lnx > $destdir/lib/config/zx81ansi.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/zx.lnx > $destdir/lib/config/zx.cfg
sed "s?DESTDIR?$destdir?g" < $destdir/lib/config/zxansi.lnx > $destdir/lib/config/zxansi.cfg
cp $destdir/lib/config/$DEFAULT.cfg $destdir/lib/config/zcc.cfg
