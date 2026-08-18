CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct results, compile for the zx spectrum target
and run in an emulator:

new/sccz80
zcc +zx -vn -startup=4 -clib=new -O2 -DSTATIC -DTIMER -DPRINTF sieve.c -o sieve -create-app

new/zsdcc
zcc +zx -vn -startup=4 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTF sieve.c -o sieve -create-app

(These compile settings were found to give the best results).

The output was run in a spectrum emulator and results were verified.

TIMING
======

To time, the program was compiled for the generic z80 target where
possible so that a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER sieve.c -o sieve -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER sieve.c -o sieve -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks sieve.bin -start 00bf -end 0159 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
sccz80 / new c library
8362 bytes less page zero

cycle count  = 4957733
time @ 4MHz  = 4957733 / 4*10^6 = 1.2394 sec


Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library
8316 bytes less page zero

cycle count  = 3679114
time @ 4MHZ  = 3679114 / 4*10^6 =    0.9 sec
