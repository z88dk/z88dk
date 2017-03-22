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

ticks whetstone.bin -start 00d1 -end 09f9 -counter 99999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
classic/sccz80/genmath
5715 bytes less page zero
40 bit mantissa + 8 bit exponent

cycle count  = 1288407230
time @ 4MHz  = 1288407230 / 4x10^6 = 322.1018  seconds
KWIPS        = 100*10*1 / 322.1018 = 3.1046
MWIPS        = 3.1046 / 1000 = 0.0031046


Z88DK March 18, 2017
classic/zsdcc #9852/math48
7049 bytes less page zero
40 bit mantissa + 8 bit exponent internal, 24 bit mantissa + 8 bit exponent exposed by compiler

cycle count  = 920888959
time @ 4MHz  = 920888959 / 4x10^6 = 230.2222 seconds
KWIPS        = 100*10*1 / 230.2222 = 4.3436
MWIPS        = 4.3436 / 1000 = 0.0043436
