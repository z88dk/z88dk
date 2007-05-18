#!/bin/sh
 
THISFILE=$1
COMPILER=/usr/local/lib/z88dk

cp $COMPILER/lib/rcmx000_crt0.opt tmp_rcmx000_crt0.opt
cp tmp_rcmx000_crt0.opt tmp_rcmx000_crt0.asm

zcpp -I. -DZ80 -DSMALL_C -DRCMX000 -D__RCMX000__ -DSCCZ80 -I$COMPILER/include  $THISFILE.c tmp_$THISFILE.i

sccz80    -//  tmp_$THISFILE.i


 copt $COMPILER/lib/z80rules.2 < tmp_$THISFILE.asm > tmp_$THISFILE.op1
 copt $COMPILER/lib/z80rules.1 < tmp_$THISFILE.op1 > tmp_$THISFILE.opt


# Produce a list file...
cp tmp_$THISFILE.opt tmp_opt_$THISFILE.asm
z80asm $FLAGS -l tmp_opt_$THISFILE.asm

z80asm $FLAGS -eopt -ns -Mo tmp_$THISFILE.opt
