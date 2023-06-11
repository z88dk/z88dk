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

zcc +rc2014 -subtype=cpm -vn -startup=0 -DSTATIC -DPRINTF -SO3 -clib=sdcc_iy --max-allocs-per-node200000 spectral-norm.c -o spectral-norm --math32 -m -create-app
zcc +rc2014 -subtype=cpm -vn -startup=0 -DSTATIC -DPRINTF -SO3 -clib=sdcc_iy --max-allocs-per-node200000 spectral-norm.c -o spectral-norm --am9511 -m -create-app

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

sccz80/new
zcc +z80 -vn -startup=0 -DSTATIC -DTIMER -O2 -clib=new spectral-norm.c -o spectral-norm -lm -m -create-app

zsdcc/new
zcc +z80 -vn -startup=0 -DSTATIC -DTIMER -SO3 -clib=sdcc_iy --max-allocs-per-node200000 spectral-norm.c -o spectral-norm -lm -m -create-app

zsdcc/new/math32
zcc +z80 -vn -startup=0 -DSTATIC -DTIMER -SO3 -clib=sdcc_iy --max-allocs-per-node200000 spectral-norm.c -o spectral-norm --math32 -m -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks spectral-norm.bin -start 06d9 -end 0800 -counter 99999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
zsdcc #11566 / new c library
3358 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8628617805
time @ 4MHz  = 8628617805 / 4*10^6 = 35 min 57 sec

Z88DK July 4, 2021
zsdcc #12419 / new c library / math32
5453 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 9947615066
time @ 4MHz  = 9947615066 / 4*10^6 = 41 min 27 sec

Z88DK April 20, 2020
sccz80 / new c library
3895 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8906227168
time @ 4MHz  = 8906227168 / 4*10^6 = 37 min 07 sec
