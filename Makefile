#
#
#	The impromptu compilation makefile for z88dk
#



all: appmake copt zcpp sccz80 z80asm zcc config


appmake:
	cd src/appmake ; make

copt:
	cd src/copt ; make

zcpp:
	cd src/cpp ; make

sccz80:
	cd src/sccz80 ; make

z80asm:
	echo 'Configure z80asm for ENDIAN status!!'
	cd src/z80asm ; make

zcc:
	cd src/zcc ; make

config:
	rm -f lib/config/*.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/cpm.lnx > lib/config/cpm.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/z88.lnx > lib/config/z88.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/zx.lnx > lib/config/zx.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/zxansi.lnx > lib/config/zxansi.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/zx81.lnx > lib/config/zx81.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/zx81ansi.lnx > lib/config/zx81ansi.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/nc.lnx > lib/config/nc.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/vz.lnx > lib/config/vz.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/vzansi.lnx > lib/config/vzansi.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/mz.lnx > lib/config/mz.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/mzansi.lnx > lib/config/mzansi.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/ti86.lnx > lib/config/ti86.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/z88net.lnx > lib/config/z88net.cfg
	sed "s?DESTDIR?`pwd`?g" < lib/config/abc80.lnx > lib/config/abc80.cfg
	ln -s z88.cfg lib/config/zcc.cfg

libs:
	cd libsrc ; make

clean:
	cd libsrc ; make clean
	cd src/sccz80 ; make clean
	cd src/cpp ; make clean
	cd src/z80asm ; make clean
	cd lib/config ; rm *.cfg
