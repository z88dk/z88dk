CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct results, compile for the zx spectrum target and
run in a spectrum emulator.

classic/sccz80/genmath : 40 bit mantissa
zcc +zx -vn -O2 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lm -lndos -create-app

classic/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lmath48 -lndos -create-app

(These compile settings were found to give the best results).

Compiles matched expected results exactly.

TIMING
======

To time, the program was compiled for the generic z80 target where
possible so that a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/genmath : 40 bit mantissa
zcc +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin -lm -lndos -m

classic/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin -lmath48 -lndos -m

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks whetstone.bin -start 00d1 -end 09f9 -counter 99999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 28, 2021
classic/sccz80/genmath
40 bit mantissa + 8 bit exponent

6359 bytes less page zero
cycle count  = 1283271893
time @ 4MHz  = 1283271893 / 4x10^6 = 320.8179 seconds
KWIPS        = 100*10*1 / 320.8179 = 3.1170
MWIPS        = 3.1170 / 1000 = 0.0031170


Z88DK April 28, 2021
classic/zsdcc #12070/math48
40 bit mantissa + 8 bit exponent internal, 24 bit mantissa + 8 bit exponent exposed by compiler
7588 bytes less page zero

cycle count  = 920781972
time @ 4MHz  = 920781972 / 4x10^6 = 230.1954 seconds
KWIPS        = 100*10*1 / 230.1954 = 4.3441
MWIPS        = 4.3441 / 1000 = 0.0043441
