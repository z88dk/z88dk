CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

new/sccz80/FAILS UNABLE TO COMPILE
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

new/sccz80/FAILS UNABLE TO COMPILE
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

Z88DK March 18, 2017
zsdcc #9852 / new
4191 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2244963926
time @ 4MHz  = 2244963926 / 4*10^6 = 9 min 21 sec
