CHANGES TO SOURCE CODE
======================

None.

The classic lib can use sccz80/genmath, sccz80/mzx, or zsdcc/math48.
The new c lib can use sccz80/math48 or zsdcc/math48.

VERIFY CORRECT RESULT
=====================

To verify correct results, we compiled for the zx spectrum target
using all combinations of compiler and math libraries:

;classic not currently working

;classic/sccz80/genmath : 40 bit mantissa
;zcc +zx -vn -O2 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lm -lndos -m -create-app

;classic/sccz80/zx spectrum rom : 32 bit mantissa
;zcc +zx -vn -O2 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lmz -lndos -m -create-app

;classic/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
;zcc +zx -vn -O2 -compiler=sdcc -SO3 --max-allocs-per-node200000 --reserve-regs-iy -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lm -lndos -m -create-app

new/sccz80/math48 : 40 bit mantissa
zcc +zx -vn -startup=4 -clib=new -O2 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lm -m -create-app

new/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +zx -vn -startup=4 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -DPRINTOUT whetstone.c -o whetstone -lm -m -create-app

(These compile settings were found to give the best results).

The output was run in a spectrum emulator and results were verified.

Compiles with >= 32 bit mantissa matched expected results exactly.
Compiles with 24 bit mantissa had small errors in the last decimal digit.

TIMING
======

To time, the program was compiled for the generic z80 target where
possible so that a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

The only exception was the zx spectrum rom float implementation
which must be run on a zx spectrum target.  For TICKS to run
this, it must be given a memory image that includes the spectrum
rom.  This was produced by dumping memory from an emulator after
loading the whetstone program from tape.

;classic not currently working

;classic/sccz80/genmath : 40 bit mantissa
;zcc +embedded -vn -O2 -DSTATIC -DTIMER whetstone.c -o whetstone -lm -lndos -m -create-app

;classic/sccz80/zx spectrum rom : 32 bit mantissa
;zcc +zx -vn -O2 -DSTATIC -DTIMER whetstone.c -o whetstone -lmz -lndos -m -create-app

;classic/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
;zcc +zx -vn -O2 -compiler=sdcc -SO3 --max-allocs-per-node200000 --reserve-regs-iy -DSTATIC -DTIMER whetstone.c -o whetstone -lm -lndos -m -create-app

new/sccz80/math48 : 40 bit mantissa
zcc +z80 -vn -startup=0 -clib=new -O2 -DSTATIC -DTIMER whetstone.c -o whetstone -lm -m -pragma-include:zpragma.inc -create-app

new/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER whetstone.c -o whetstone -lm -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks whetstone.bin -start 08bc -end 13be -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 2, 2017
ZSDCC #9833

new/sccz80/math48
5483 bytes less page zero
40 bit mantissa + 8 bit exponent

cycle count  = 970198993
time @ 4MHz  = 970198993 / 4x10^6 = 242.5497  seconds
KWIPS        = 100*10*1 / 242.5497 = 4.1229
MWIPS        = 4.1229 / 1000 = 0.0041229

new/zsdcc/math48
6153 bytes less page zero
40 bit mantissa + 8 bit exponent internal, 24 bit mantissa + 8 bit exponent exposed by compiler

cycle count  = 916537242
time @ 4MHz  = 916537242 / 4x10^6 = 229.1343 seconds
KWIPS        = 100*10*1 / 229.1343 = 4.3643
MWIPS        = 4.3643 / 1000 = 0.0043643
