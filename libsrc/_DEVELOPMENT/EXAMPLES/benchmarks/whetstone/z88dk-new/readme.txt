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
zcc +zx -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone --math32 -m -create-app

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
zcc +z80 -vn -startup=0 -clib=new -O3 --opt-code-speed=inlineints -DSTATIC -DTIMER whetstone.c -o whetstone --math32 -m -pragma-include:zpragma.inc -create-app

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

Z88DK April 28, 2021
sccz80 / new c library / math48
40 bit mantissa + 8 bit exponent
5362 bytes less page zero

cycle count  = 972899568
time @ 4MHz  = 972899568 / 4x10^6 = 243.2248 seconds
KWIPS        = 100*10*1 / 243.2248 = 4.1114
MWIPS        = 4.1114 / 1000 = 0.0041114


Z88DK January 3, 2022
sccz80 / new c library / math32
24 bit mantissa + 8 bit exponent
8861 bytes less page zero

cycle count  = 568209557
time @ 4MHz  = 568209557 / 4x10^6 = 142.0524 seconds
KWIPS        = 100*10*1 / 142.0524 = 7.0396
MWIPS        = 7.0396 / 1000 = 0.0070396


Z88DK April 28, 2021
zsdcc #12070 / new c library / math48
40 bit mantissa + 8 bit exponent internal, 24 bit mantissa + 8 bit exponent exposed by compiler
6221 bytes less page zero

cycle count  = 914412771
time @ 4MHz  = 914412771 / 4x10^6 = 228.6031 seconds
KWIPS        = 100*10*1 / 228.6031 = 4.3743
MWIPS        = 4.3743 / 1000 = 0.0043743


Z88DK April 30, 2021
zsdcc #12250 / new c library / math32
24 bit mantissa + 8 bit exponent
10113 bytes less page zero

cycle count  = 576187434
time @ 4MHz  = 576187434 / 4x10^6 = 144.0468 seconds
KWIPS        = 100*10*1 / 144.0468 = 6.9421
MWIPS        = 6.9421 / 1000 = 0.0069421
