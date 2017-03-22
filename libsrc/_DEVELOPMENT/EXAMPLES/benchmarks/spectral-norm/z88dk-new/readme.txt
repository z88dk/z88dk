CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

sccz80/new
zcc +zx -vn -DSTATIC -DPRINTF -O2 -clib=new spectral-norm.c -o spectral-norm -lm -create-app
error: 2 * 10^(-9)

zsdcc/new
zcc +zx -vn -DSTATIC -DPRINTF -SO3 -clib=sdcc_iy --max-allocs-per-node200000 spectral-norm.c -o spectral-norm -lm -create-app
error: 2 * 10^(-9)

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

sccz80/new
zcc +z80 -vn -startup=0 -DSTATIC -DTIMER -O2 -clib=new spectral-norm.c -o spectral-norm -lm -m -create-app

zsdcc/new
zcc +z80 -vn -startup=0 -DSTATIC -DTIMER -SO3 -clib=sdcc_iy --max-allocs-per-node200000 spectral-norm.c -o spectral-norm -lm -m -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks spectral-norm.bin -start 06d9 -end 0800 -counter 99999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK March 18, 2017
zsdcc #9852 / new c library
3398 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8617066395
time @ 4MHz  = 8617066395 / 4*10^6 = 35 min 54 sec


Z88DK March 18, 2017
sccz80 / new c library
4026 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 9271618782
time @ 4MHz  = 9271618782 / 4*10^6 = 38 min 38 sec
