CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct results, compile for the zx spectrum target and
run in a spectrum emulator.

new/sccz80/math48 : 40 bit mantissa
zcc +zx -vn -startup=4 -clib=new -O2 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lm -m -create-app

new/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +zx -vn -startup=4 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lm -m -create-app

new/zsdcc/math32: 24 bit mantissa
zcc +cpm -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone --math32 -m -create-app

(These compile settings were found to give the best results).

Compiles matched expected results exactly.

TIMING
======

To time, the program was compiled for the generic z80 target where
possible so that a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80/math48 : 40 bit mantissa
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER whetstone.c -o whetstone -lm -m -pragma-include:zpragma.inc -create-app

new/sccz80/math32 : 24 bit mantissa
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER whetstone.c -o whetstone --math32 -m -pragma-include:zpragma.inc -create-app

new/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER whetstone.c -o whetstone -lm -m -pragma-include:zpragma.inc -create-app

new/zsdcc/math32 : 24 bit mantissa
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER whetstone.c -o whetstone --math32 -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks whetstone.bin -start 08bc -end 13be -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
sccz80 / new c library / math48
40 bit mantissa + 8 bit exponent
5388 bytes less page zero

cycle count  = 973210939
time @ 4MHz  = 973210939 / 4x10^6 = 243.3027 seconds
KWIPS        = 100*10*1 / 243.3027 = 4.1101
MWIPS        = 4.1101 / 1000 = 0.0041101


Z88DK July 13, 2020
sccz80 / new c library / math32
24 bit mantissa + 8 bit exponent
8823 bytes less page zero

cycle count  = 653436776
time @ 4MHz  = 653436776 / 4x10^6 = 163.3592 seconds
KWIPS        = 100*10*1 / 163.3592 = 6.1215
MWIPS        = 6.1215 / 1000 = 0.0061215


Z88DK April 20, 2020
zsdcc #11566 / new c library / math48
40 bit mantissa + 8 bit exponent internal, 24 bit mantissa + 8 bit exponent exposed by compiler
6234 bytes less page zero

cycle count  = 916707945
time @ 4MHz  = 916707945 / 4x10^6 = 229.1770 seconds
KWIPS        = 100*10*1 / 229.1770 = 4.3634
MWIPS        = 4.3634 / 1000 = 0.0043634


Z88DK July 13, 2020
zsdcc #11722 / new c library / math32
24 bit mantissa + 8 bit exponent
9681 bytes less page zero

cycle count  = 663018211
time @ 4MHz  = 663018211 / 4x10^6 = 165.7546 seconds
KWIPS        = 100*10*1 / 165.7546 = 6.0330
MWIPS        = 6.0330 / 1000 = 0.0060330
