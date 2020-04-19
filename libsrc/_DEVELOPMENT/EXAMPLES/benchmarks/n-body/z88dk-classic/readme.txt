CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 n-body.c -o n-body -lm -lndos -create-app

classic/sccz80/math32
zcc +zx -vn -DSTATIC -DPRINTF -O2 n-body.c -o n-body --math32 -lndos -create-app

classic/zsdcc
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc -SO3 --max-allocs-per-node200000 n-body.c -o n-body -lmath48 -lndos -create-app
first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 n-body.c -o n-body.bin -lm -m -lndos

classic/sccz80/math32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 n-body.c -o n-body.bin --math32 -m -lndos

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 n-body.c -o n-body.bin -lmath48 -m -lndos

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

ticks n-body.bin -start 0dc6 -end 0e25 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 20, 2020
zsdcc #11566 / classic
4770 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 2253531346
time @ 4MHz  = 2253531346 / 4*10^6 = 9 min 23 sec


Z88DK April 20, 2020
sccz80 / classic
3814 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 3624577433
time @ 4MHz  = 3624577433 / 4*10^6 = 15 min 06 sec


Z88DK April 20, 2020
sccz80 / classic / math32
5333 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-6)

cycle count  = 1358606369
time @ 4MHz  = 1358606369 / 4*10^6 =  5 min 40 sec
