CHANGES TO SOURCE CODE
======================

When built with --math16 (__MATH_MATH16), floating types use _Float16,
invsqrtf16/sqrtf16, and DT=1e-1 so intermediate values stay in half range.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

classic/sccz80
zcc +zx -vn -DSTATIC -DPRINTF -O2 n-body.c -o n-body -lm -lndos -create-app

classic/sccz80/8085/MBF32
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 n-body.c -o n-body --math-mbf32 -lndos -create-app

classic/sccz80/math32
zcc +zx -vn -DSTATIC -DPRINTF -O2 n-body.c -o n-body --math32 -lndos -create-app

classic/sccz80/8085/math32
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 n-body.c -o n-body --math32 -lndos -create-app

classic/sccz80/math16
zcc +zx -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints n-body.c -o n-body --math16 -lndos -create-app

classic/sccz80/8085/math16
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints n-body.c -o n-body --math16 -lmath32_8085 -lndos -create-app

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

classic/sccz80/MBF32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 n-body.c -o n-body.bin --math-mbf32 -m -lndos

classic/sccz80/8085/MBF32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 n-body.c -o n-body.bin --math-mbf32 -m -lndos

classic/sccz80/math32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 n-body.c -o n-body.bin --math32 -m -lndos

classic/sccz80/math16
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints n-body.c -o n-body.bin --math16 -m -lndos

classic/sccz80/8085/math32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 n-body.c -o n-body.bin --math32 -m -lndos

classic/sccz80/8085/math16
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints n-body.c -o n-body.bin --math16 -lmath32_8085 -m -lndos

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 n-body.c -o n-body.bin -lmath48 -m -lndos

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks n-body.bin -x n-body.map -start TIMER_START -end TIMER_STOP -counter 999999999999

For 8085 binaries add -m8085:

z88dk-ticks -m8085 n-body.bin -x n-body.map -start TIMER_START -end TIMER_STOP -counter 999999999999

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


Z88DK January 3, 2022
sccz80 / classic
4527 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 3659884553
time @ 4MHz  = 3659884553 / 4*10^6 = 15 min 15 sec


Z88DK July 19, 2026
sccz80 / classic / 8085 / MBF32
4729 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1849800062
time @ 4MHz  = 1849800062 / 4*10^6 =  7 min 42 sec


Z88DK July 19, 2026
sccz80 / classic / MBF32
4956 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1835079611
time @ 4MHz  = 1835079611 / 4*10^6 =  7 min 39 sec


Z88DK August 10, 2026
sccz80 / classic / math32
5672 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 791103882
time @ 4MHz  = 791103882 / 4*10^6 =  3 min 18 sec


Z88DK August 15, 2026
sccz80 / classic / 8085 / math32
6930 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 7 * 10^(-6)

cycle count  = 1526136021
time @ 4MHz  = 1526136021 / 4*10^6 =  6 min 22 sec

Energy: -0.1690752 / -0.1690808 (N=1000).


Z88DK August 10, 2026
sccz80 / classic / math16
4248 bytes less page zero

cycle count  = 295642916
time @ 4MHz  = 295642916 / 4*10^6 =  1 min 14 sec

IEEE 16-bit half-float (math16). DT=1e-1 for half range.


Z88DK August 10, 2026
sccz80 / classic / 8085 / math16
4024 bytes less page zero

cycle count  = 344383717
time @ 4MHz  = 344383717 / 4*10^6 =  1 min 26 sec

IEEE 16-bit half-float (math16_8085). DT=1e-1 for half range.
