CHANGES TO SOURCE CODE
======================

None.

sccz80 is unable to compile this benchmark due to the presence
of a two dimensional array.

VERIFY CORRECT RESULT
=====================

To verify correct result, we compiled for the zx spectrum target
using zsdcc as compiler with the new c library:

new/zsdcc
zcc +zx -vn -startup=4 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DNOSTRUCTASSIGN -DTIMER -DPRINTF dhry_1.c dhry_2.c -o dhry -lm -create-app

(These compile settings were found to give the best result).

The output was run in a spectrum emulator and results were verified.

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

ticks dhry.bin -start 01a8 -end 0318 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 2, 2017
ZSDCC #9833

new/zsdcc (7126 bytes less page zero)

cycle count  = 248762927
time @ 4MHz  = 248762927 / 4x10^6 = 62.1907  seconds
dhrystones/s = 20000 / 62.1907 = 321.5913
DMIPS        = 321.5913 / 1757 = 0.18303
