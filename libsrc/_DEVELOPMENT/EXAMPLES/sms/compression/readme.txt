Compression
===========

This program verifies that zx7 and aplib decompression is working.

Compile with zsdcc (the high optimization setting can lead to long compile times):

zcc +sms -vn -startup=1 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 compression.c binaries.asm -o compression -pragma-include:zpragma.inc -create-app -m

Compile with sccz80:

zcc +sms -vn -startup=1 -clib=new -O3 compression.c binaries.asm -o compression -pragma-include:zpragma.inc -create-app -m

The "-m" option generates a map file which will show the addresses of the TIMER labels that can be used to time the decompression functions.

Timed with Meka:

aplib decompression: 935,222 cycles
zx7   decompression: 478,160 cycles

There is a faster version of aplib available that comes at the expense of code size that may be incorporated into Z88DK in the future.
