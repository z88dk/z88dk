#!/bin/sh
 
COMPILER=/usr/local/lib/z88dk


z80asm $FLAGS -a -m -Mo -oa.bin -i$COMPILER/lib/clibs/ndos  -i$COMPILER/lib/clibs/rcmx000_clib  -i$COMPILER/lib/clibs/z80_crt0  tmp_rcmx000_crt0.opt $@

