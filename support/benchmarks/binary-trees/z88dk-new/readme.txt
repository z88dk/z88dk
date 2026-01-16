CHANGES TO SOURCE CODE
======================

none.

VERIFY CORRECT RESULT
=====================

To verify the correct result, compile for the zx spectrum target and
run in a spectrum emulator.

new/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -startup=5 -O2 -clib=new binary-trees.c -o bt -lm -create-app

new/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -startup=5 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 binary-trees.c -o bt -lm -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new binary-trees.c -o bt -lm -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 binary-trees.c -o bt -lm -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks bt.bin -start 0908 -end 0a80 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
new/sccz80
2711 bytes less page zero

cycle count  = 6582763903
time @ 4MHz  = 6582763903 / 4*10^6 = 27 min 25 sec


Z88DK April 20, 2020
new/zsdcc #11566
2689 bytes less page zero

cycle count  = 6576349618
time @ 4MHz  = 6576349618 / 4*10^6 = 27 min 24 sec
