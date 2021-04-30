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

z88dk-ticks n-body.bin -start 0dc6 -end 0e25 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 28, 2021
zsdcc #12070 / classic
5246 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 2253709929
time @ 4MHz  = 2253709929 / 4*10^6 = 9 min 23 sec


Z88DK April 28, 2021
sccz80 / classic
4493 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 3658052111
time @ 4MHz  = 3658052111 / 4*10^6 = 15 min 14 sec


Z88DK April 30, 2021
sccz80 / classic / math32
6018 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 993265277
time @ 4MHz  = 993265277 / 4*10^6 =  4 min 8 sec
