CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct result, compile for the zx spectrum target
and run in an emulator.

sccz80/classic
zcc +zx -vn -O2 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

zsdcc/classic
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

sccz80/classic
zcc +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

zsdcc/classic
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

In each case, the map file was used to look up symbols "TIMER_START"
and "TIMER_STOP".  These address bounds were given to TICKS to measure
execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks pi.bin -start 00bb -end 01e9 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

PI.C


Z88DK April 20, 2020
sccz80 / classic c library
6508 bytes less page zero

cycle count  = 4012440830
time @ 4MHz  = 4012440830 / 4*10^6 = 16 min 43 sec


Z88DK April 20, 2020
zsdcc #11566 / classic c library
6600 bytes less page zero

cycle count  = 4169137078
time @ 4MHz  = 4169137078 / 4*10^6 = 17 min 22 sec
