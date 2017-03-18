CHANGES TO SOURCE CODE
======================

None.

sccz80 is unable to compile this benchmark due to the presence
of a two dimensional array.

VERIFY CORRECT RESULT
=====================

To verify correct result, compile for the zx spectrum target and
run in an emulator.

classic/zsdcc
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DNOSTRUCTASSIGN -DPRINTF dhry_1.c dhry_2.c -o dhry -lmath48 -lndos -create-app

(These compile settings were found to give the best result).

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/zsdcc
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DNOSTRUCTASSIGN -DTIMER -D__Z88DK dhry_1.c dhry_2.c -o dhry.bin -m -lndos

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks dhry.bin -start 011f -end 027f -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
classic/zsdcc #9852
7265 bytes less page zero

cycle count  = 247720320
time @ 4MHz  = 247720320 / 4x10^6 = 61.9301  seconds
dhrystones/s = 20000 / 61.9301 = 322.9448
DMIPS        = 322.9448 / 1757 = 0.18380
