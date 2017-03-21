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

ticks pi.bin -start 00bb -end 01e9 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

PI.C


Z88DK March 18, 2017
sccz80 / classic c library
6387 bytes less page zero

cycle count  = 5391508326
time @ 4MHz  = 5391508326 / 4*10^6 = 22 min 29 sec


Z88DK March 18, 2017
zsdcc #9852 / classic c library
6484 bytes less page zero

cycle count  = 5377063339
time @ 4MHz  = 5377063339 / 4*10^6 = 22 min 24 sec
