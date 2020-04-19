CHANGES TO SOURCE CODE
======================

none.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx spectrum target and
run in a spectrum emulator.

new/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -startup=5 -O2 -clib=new fannkuch.c -o fannkuch -create-app

new/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -DINLINE -startup=5 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 fannkuch.c -o fannkuch -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new fannkuch.c -o fannkuch -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -DINLINE -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 fannkuch.c -o fannkuch -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks fannkuch.bin -start 0411 -end 0418 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
new/sccz80
957 bytes less page zero

cycle count  = 77386481
time @ 4MHz  = 77386481 / 4*10^6 = 19.35 sec


Z88DK April 20, 2020
new/zsdcc #11566
1070 bytes less page zero

cycle count  = 56090095
time @ 4MHz  = 56090095 / 4*10^6 = 14.02 sec
