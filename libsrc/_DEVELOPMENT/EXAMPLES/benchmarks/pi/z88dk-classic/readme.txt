CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct result, compile for the zx spectrum target
and run in an emulator.

classic/sccz80/8085
zcc +cpm -clib=8085 -vn -O2 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

sccz80/classic
zcc +zx -vn -O2 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

zsdcc/classic
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DPRINTF pi.c -o pi -lndos -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/8085
zcc +test -clib=8085 -vn -O2 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

sccz80/classic
zcc +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

zsdcc/classic
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK pi.c -o pi.bin -lndos -m

In each case, the map file was used to look up symbols "TIMER_START"
and "TIMER_STOP".  These address bounds were given to TICKS to measure
execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks pi.bin -x pi.map -start TIMER_START -end TIMER_STOP -counter 9999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

PI.C


Z88DK December 12, 2022
sccz80 / classic c library / 8085 CPU
7335 bytes less page zero

cycle count  = 7824146079
time @ 4MHz  = 7824146079 / 4*10^6 = 32 min 36 sec


Z88DK April 4, 2022
sccz80 / classic c library
7154 bytes less page zero

cycle count  = 4028061102
time @ 4MHz  = 4028061102 / 4*10^6 = 16 min 47 sec


Z88DK April 4, 2022
zsdcc #13131 / classic c library
7146 bytes less page zero

cycle count  = 4013954322
time @ 4MHz  = 4013954322 / 4*10^6 = 16 min 43 sec
