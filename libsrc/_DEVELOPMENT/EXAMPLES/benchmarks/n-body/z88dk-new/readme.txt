CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

new/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 -clib=new n-body.c -o n-body -lm -create-app

new/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -SO3 -clib=sdcc_iy --max-allocs-per-node200000 n-body.c -o n-body -lm -create-app
first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new n-body.c -o n-body -lm -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 n-body.c -o n-body -lm -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks n-body.bin -start 0f18 -end 0f77 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
zsdcc #11566 / new
4356 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2247600377
time @ 4MHz  = 2247600377 / 4*10^6 = 9 min 22 sec


Z88DK April 20, 2020
sccz80 / new
3244 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 2374676379
time @ 4MHz  = 2374676379 / 4*10^6 = 9 min 54 sec
