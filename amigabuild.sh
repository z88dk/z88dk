#!/bin/sh
#
#
# Bootstrap an amiga build from scratch, first build the unix system in
# situ
#


Z80_OZFILES=`pwd`/lib/
ZCCCFG=`pwd`/lib/config/
export Z80_OZFILES
export ZCCCFG

CC=gcc
CFLAGS="-g -O2"
CCOPT=-DUNIX
export CC
export CFLAGS
export CCOPT

PATH=`pwd`/bin:$PATH
export PATH
make -e
#make -C `pwd`/libsrc
#make -C `pwd`/libsrc install

# That's the unix part bootstrapped, now onto the Amiga


#CC="dcc -unixrc"
CC="m68k-amigaos-gcc -noixemul"
CFLAGS="-g -O2" 
CCOPT=-DAMIGA
DESTDIR=`pwd`/amiga/bin

export CC
export CFLAGS
export CCOPT

make -C `pwd` -e amiga

cat > z88dk/bin/startzcc << EOD
; Set up of Z88DK for the Amiga
; 28/2/99 djm
; 26/4/99 djm Made Hopefully independent of where the thing is
; 8/12/02 djm Remove the annoying zlib: assign

;Root directory for everything - remember to change this if you move it!

assign zcc: /

;Path to executables!
path zcc:bin add

;Set some variables for z80asm (so it can find various files)
setenv Z80_OZFILES zcc:lib/

; Set the variable so ZCC knows where to find its config file
setenv ZCCCFG zcc:lib/config/
EOD

rm -fr `find z88dk -type d -name 'CVS'`
lha a z88dk-amiga-1.5.lha z88dk/


