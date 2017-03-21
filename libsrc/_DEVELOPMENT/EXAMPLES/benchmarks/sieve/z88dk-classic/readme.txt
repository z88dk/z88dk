CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct results, compile for the zx spectrum target
and run in an emulator:

sccz80/classic
zcc +zx -vn -O2 -DSTATIC -DPRINTF sieve.c -o sieve -lndos -create-app

zsdcc/classic
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DPRINTF sieve.c -o sieve -lndos -create-app

(These compile settings were found to give the best results).

TIMING
======

To time, the program was compiled for the generic z80 target where
possible so that a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

sccz80/classic
zcc +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK sieve.c -o sieve.bin -lndos -m

zsdcc/classic
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK sieve.c -o sieve.bin -lndos -m

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks sieve.bin -start 00ca -end 0164 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
sccz80 / classic c library
8566 bytes less page zero

cycle count  = 5894225
time @ 4MHz  = 5894225 / 4*10^6 = 1.4736 sec


Z88DK March 18, 2017
zsdcc #9852 / classic c library
8521 bytes less page zero

cycle count  = 4513446
time @ 4MHZ  = 4513446 / 4*10^6 = 1.1284 sec
