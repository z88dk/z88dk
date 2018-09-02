#!/bin/sh

zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o mvtmp -pragma-include:zpragma.inc -subtype=dotn -Cz"--clean" -create-app
rm -f mvtmp_UNASSIGNED.bin zcc_opt.def
