CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

new/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -startup=4 -O2 -clib=new fasta.c -o fasta -lm -create-app

new/sccz80/math32
zcc +zx -vn -DSTATIC -DPRINTF -startup=4 -O2 -clib=new fasta.c -o fasta --math32 -create-app

new/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -startup=4 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta -lm -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new fasta.c -o fasta -lm -m -pragma-include:zpragma.inc -create-app

new/sccz80/math32
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new fasta.c -o fasta --math32 -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 --fsigned-char fasta.c -o fasta -lm -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks fasta.bin -start 0991 -end 0a04 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
new/zsdcc #11566
3171 bytes less page zero

cycle count  = 245055005
time @ 4MHz  = 245055005 / 4*10^6 = 61.26 sec


Z88DK April 20, 2020
new/sccz80
2998 bytes less page zero

cycle count  = 204281085
time @ 4MHz  = 204281085 / 4*10^6 = 51.07 sec


Z88DK April 20, 2020
new/sccz80/math32
3729 bytes less page zero

cycle count  = 136057141
time @ 4MHz  = 136057141 / 4*10^6 = 34.01 sec
