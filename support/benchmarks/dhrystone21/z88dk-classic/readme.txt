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
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DPRINTF dhry_1.c dhry_2.c -o dhry -lmath48 -lndos -create-app

(These compile settings were found to give the best result).

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/zsdcc
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DTIMER -D__Z88DK dhry_1.c dhry_2.c -o dhry.bin -m -lndos

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks dhry.bin -start 018a -end 02b5 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 10, 2022
classic/zsdcc #13131
7882 bytes less page zero

cycle count  = 251880052
time @ 4MHz  = 251880052 / 4x10^6 = 62.97 seconds
dhrystones/s = 20000 / 62.97 = 317.6115
DMIPS        = 317.6115 / 1757 = 0.18077
