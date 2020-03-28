#!/bin/sh

zx7 -f mv-help.txt
zcc +zxn -v -m -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o mv -pragma-include:zpragma.inc -subtype=dotn -Cz"--clean" -create-app
rm -f mv_UNASSIGNED.bin zcc_opt.def mv-help.txt.zx7
