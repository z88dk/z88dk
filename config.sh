#!/bin/sh

# Some script hackery to allow global installs


destdir=$1

DEFAULT=$2



rm -f lib/config/*.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/abc80.lnx > lib/config/abc80.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/aceansi.lnx > lib/config/aceansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/aquarius.lnx > lib/config/aquarius.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/aquansi.lnx > lib/config/aquansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/c128ansi.lnx > lib/config/c128ansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/cpm.lnx > lib/config/cpm.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/cpc.lnx > lib/config/cpc.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/embedded.lnx > lib/config/embedded.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/m5.lnx > lib/config/m5.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/msx.lnx > lib/config/msx.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/mz.lnx > lib/config/mz.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/mzansi.lnx > lib/config/mzansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/nc.lnx > lib/config/nc.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/pps.lnx > lib/config/pps.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ppsansi.lnx > lib/config/ppsansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/rex.lnx > lib/config/rex.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/rexlib.lnx > lib/config/rexlib.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/sam.lnx > lib/config/sam.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/svi.lnx > lib/config/svi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti82.lnx > lib/config/ti82.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti82ansi.lnx > lib/config/ti82ansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti83.lnx > lib/config/ti83.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti83ansi.lnx > lib/config/ti83ansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti8x.lnx > lib/config/ti8x.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti8xansi.lnx > lib/config/ti8xansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti85.lnx > lib/config/ti85.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti85ansi.lnx > lib/config/ti85ansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti86.lnx > lib/config/ti86.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/ti86ansi.lnx > lib/config/ti86ansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/vz.lnx > lib/config/vz.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/vzansi.lnx > lib/config/vzansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/z88.lnx > lib/config/z88.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/z88ansi.lnx > lib/config/z88ansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/z88net.lnx > lib/config/z88net.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/zx81.lnx > lib/config/zx81.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/zx81ansi.lnx > lib/config/zx81ansi.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/zx.lnx > lib/config/zx.cfg
sed "s?DESTDIR\/?$destdir?g" < lib/config/zxansi.lnx > lib/config/zxansi.cfg
cp lib/config/$DEFAULT.cfg lib/config/zcc.cfg
