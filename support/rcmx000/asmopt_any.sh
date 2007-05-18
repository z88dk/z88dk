#!/bin/sh
 
THISFILE=$1
COMPILER=/usr/local/lib/z88dk


 copt $COMPILER/lib/z80rules.2 < $THISFILE.asm > tmp_$THISFILE.op1
 copt $COMPILER/lib/z80rules.1 < tmp_$THISFILE.op1 > tmp_$THISFILE.opt


# Produce a list file
cp tmp_$THISFILE.opt tmp_opt_$THISFILE.asm

z80asm $FLAGS -l tmp_opt_$THISFILE.asm

z80asm $FLAGS -eopt -ns -Mo tmp_$THISFILE.opt
