CHANGES TO SOURCE CODE
======================

When built with --math16 (__MATH_MATH16), floating types use _Float16
and sqrtf16. Matrix elements and intermediate norms stay in half range.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

classic/sccz80/8085/MBF32
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 spectral-norm.c -o spectral-norm --math-mbf32 -lndos -create-app

sccz80/classic
zcc +zx -vn -DSTATIC -DPRINTF -O2 spectral-norm.c -o spectral-norm -lm -lndos -create-app
zcc +zx -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm --math32 -lndos -create-app
error: 2 * 10^(-9)

sccz80/classic/8085/math32
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm --math32 -lndos -create-app

80cc/classic/math32
zcc +test -compiler=80cc -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm --math32 -lndos

80cc/classic/8085/math32
zcc +test -clib=8085 -compiler=80cc -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm --math32 -lndos

zsdcc/classic
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc -SO3 --max-allocs-per-node200000 spectral-norm.c -o spectral-norm -lmath48 -lndos -create-app
error: 2 * 10^(-9)

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

sccz80/classic/8085/MBF32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 spectral-norm.c -o spectral-norm.bin --math-mbf32 -lndos -m

sccz80/classic
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 spectral-norm.c -o spectral-norm.bin -lm -lndos -m
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 spectral-norm.c -o spectral-norm.bin --math-mbf32 -lndos -m
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm.bin --math32 -lndos -m

sccz80/classic/8085/math32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm.bin --math32 -lndos -m

sccz80/classic/math16
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm.bin --math16 -lndos -m

sccz80/classic/8085/math16
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm.bin --math16 -lmath32_8085 -lndos -m

80cc/classic/math32
zcc +test -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm.bin --math32 -lndos -m

80cc/classic/8085/math32
zcc +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm.bin --math32 -lndos -m

zsdcc/classic
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 spectral-norm.c -o spectral-norm.bin -lmath48 -lndos -m
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 spectral-norm.c -o spectral-norm.bin --math32 -lndos -m

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks spectral-norm.bin -x spectral-norm.map -start TIMER_START -end TIMER_STOP -counter 999999999999

For 8085 binaries add -m8085.

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK April 30, 2021
zsdcc #12250 / classic c library / math48
3984 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8617785182
time @ 4MHz  = 8617785182 / 4*10^6 = 35 min 54 sec


Z88DK August 10, 2026
zsdcc #12555 / classic c library / math32
5699 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4425446444
time @ 4MHz  = 4425446444 / 4*10^6 =  18 min 26 sec


Z88DK April 20, 2020
sccz80 / classic c library / genmath
4137 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 14688455657
time @ 4MHz  = 14688455657 / 4*10^6 = 61 min 12 sec


Z88DK August 10, 2026
sccz80 / classic c library / math32
5542 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4212448031
time @ 4MHz  = 4212448031 / 4*10^6 =  17 min 33 sec


Z88DK August 10, 2026
sccz80 / classic c library / 8085 / math32
6707 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 9013766882
time @ 4MHz  = 9013766882 / 4*10^6 =  37 min 33 sec


Z88DK August 10, 2026
80cc / classic c library / math32
5890 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4716380923
time @ 4MHz  = 4716380923 / 4*10^6 =  19 min 39 sec


Z88DK August 10, 2026
80cc / classic c library / 8085 / math32
7003 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 9819185683
time @ 4MHz  = 9819185683 / 4*10^6 =  40 min 55 sec


Z88DK July 19, 2026
sccz80 / classic c library / MBF32
4705 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6346228466
time @ 4MHz  = 6346228466 / 4*10^6 = 26 min 27 sec


Z88DK July 19, 2026
sccz80 / classic c library / 8085 / MBF32
4480 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6227757878
time @ 4MHz  = 6227757878 / 4*10^6 = 25 min 57 sec


Z88DK August 10, 2026
sccz80 / classic c library / math16
3833 bytes less page zero

cycle count  = 2531057653
time @ 4MHz  = 2531057653 / 4*10^6 =  10 min 33 sec

IEEE 16-bit half-float implementation (math16).


Z88DK August 10, 2026
sccz80 / classic c library / 8085 / math16
3802 bytes less page zero

cycle count  = 3438830098
time @ 4MHz  = 3438830098 / 4*10^6 =  14 min 20 sec

IEEE 16-bit half-float implementation (math16_8085).
