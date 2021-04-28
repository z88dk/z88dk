CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

new/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 -clib=new n-body.c -o n-body -lm -create-app
zcc +zx -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints -clib=new n-body.c -o n-body --math32 -create-app
zcc +zx -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints -clib=new n-body.c -o n-body --math16 --math32 -create-app

new/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -SO3 -clib=sdcc_iy --max-allocs-per-node200000 n-body.c -o n-body -lm -create-app
zcc +zx -vn -DSTATIC -DPRINTF -SO3 -clib=sdcc_iy --max-allocs-per-node200000 n-body.c -o n-body --math32 -create-app
first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new n-body.c -o n-body -lm -m -pragma-include:zpragma.inc -create-app
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O3 --opt-code-speed=inlineints -clib=new n-body.c -o n-body --math32 -m -pragma-include:zpragma.inc -create-app
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O3 --opt-code-speed=inlineints -clib=new n-body.c -o n-body --math16 -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 n-body.c -o n-body -lm -m -pragma-include:zpragma.inc -create-app
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 n-body.c -o n-body --math32 -m -pragma-include:zpragma.inc -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks n-body.bin -start 0f18 -end 0f77 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 28, 2021
zsdcc #12070 / new
4332 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2247889896
time @ 4MHz  = 2247889896 / 4*10^6 = 9 min 22 sec

Z88DK April 28, 2021
zsdcc #12070 / new / math32
6318 bytes less page zero

first number error : 5 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 821754212
time @ 4MHz  = 821754212 / 4*10^6 = 3 min 25 sec

Z88DK April 28, 2021
sccz80 / new
3363 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2376486525
time @ 4MHz  = 2376486525 / 4*10^6 = 9 min 53 sec

Z88DK April 28, 2021
sccz80 / new / math32
5149 bytes less page zero

first number error : 5 * 10^(-7)
second number error: 1 * 10^(-6)

cycle count  = 762845940
time @ 4MHz  = 762845940 / 4*10^6 = 3 min 11 sec

Z88DK June 28, 2020
sccz80 / new / math16
3222 bytes less page zero

first number error : 5 * 10^(-4)
second number error: 5 * 10^(-2)

cycle count  = 384070543
time @ 4MHz  = 384070543 / 4*10^6 = 1 min 36 sec
