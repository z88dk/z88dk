Before z88dk v2.5, newlib `-lm` in these recipes linked math48 (6-byte). From v2.5, `-lm` links math32. A 6-byte rerun is `--math48` with sccz80 or 80cc (zsdcc still stores 4-byte IEEE). 8-byte Microsoft format is `--mbf64` with either compiler.

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


Z88DK September 17, 2026
sccz80 / new c library / math32
24 bit mantissa + 8 bit exponent
9435 bytes less page zero

cycle count  = 356445903
time @ 4MHz  = 356445903 / 4x10^6 = 89.1115 seconds
KWIPS        = 100*10*1 / 89.1115 = 11.2219
MWIPS        = 11.2219 / 1000 = 0.0112219


Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / math48
40 bit mantissa + 8 bit exponent internal, 24 bit mantissa + 8 bit exponent exposed by compiler
6176 bytes less page zero

cycle count  = 912560516
time @ 4MHz  = 912560516 / 4x10^6 = 228.1401 seconds
KWIPS        = 100*10*1 / 228.1401 = 4.3833
MWIPS        = 4.3833 / 1000 = 0.0043833


Z88DK September 17, 2026
zsdcc 4.6.0 #16639 / new c library / math32
24 bit mantissa + 8 bit exponent
10217 bytes less page zero

cycle count  = 360608050
time @ 4MHz  = 360608050 / 4x10^6 = 90.1520 seconds
KWIPS        = 100*10*1 / 90.1520 = 11.0924
MWIPS        = 11.0924 / 1000 = 0.0110924
