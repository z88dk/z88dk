CHANGES TO SOURCE CODE
======================

None.

sccz80 is unable to compile this benchmark due to the presence
of a two dimensional array.

VERIFY CORRECT RESULT
=====================

To verify correct result, compile for the zx spectrum target and
run on an emulator.

new/zsdcc
zcc +zx -vn -startup=4 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DNOSTRUCTASSIGN -DTIMER -DPRINTF dhry_1.c dhry_2.c -o dhry -lm -create-app

(These compile settings were found to give the best result).

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/zsdcc
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DNOSTRUCTASSIGN -DTIMER dhry_1.c dhry_2.c -o dhry -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks dhry.bin -start 01a8 -end 0316 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
new/zsdcc #9852
7124 bytes less page zero

cycle count  = 248842927
time @ 4MHz  = 248842927 / 4x10^6 = 62.2107  seconds
dhrystones/s = 20000 / 62.2107 = 321.4879
DMIPS        = 321.4879 / 1757 = 0.18298
