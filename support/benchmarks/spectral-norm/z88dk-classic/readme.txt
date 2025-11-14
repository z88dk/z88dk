CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify the correct result compile for the zx spectrum target
and run in an emulator.

classic/sccz80/8085/MBF32
zcc +cpm -clib=8085 -vn -DSTATIC -DPRINTF -O2 spectral-norm.c -o spectral-norm --math-mbf32_8085 -lndos -create-app

sccz80/classic
zcc +zx -vn -DSTATIC -DPRINTF -O2 spectral-norm.c -o spectral-norm -lm -lndos -create-app
zcc +zx -vn -DSTATIC -DPRINTF -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm --math32 -lndos -create-app
error: 2 * 10^(-9)

zsdcc/classic
zcc +zx -vn -DSTATIC -DPRINTF -compiler=sdcc -SO3 --max-allocs-per-node200000 spectral-norm.c -o spectral-norm -lmath48 -lndos -create-app
error: 2 * 10^(-9)

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

sccz80/classic/8085
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O2 spectral-norm.c -o spectral-norm.bin  --math-mbf32_8085 -lndos -m

sccz80/classic
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 spectral-norm.c -o spectral-norm.bin -lm -lndos -m
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 spectral-norm.c -o spectral-norm.bin  --math-mbf32_8085 -lndos -m
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints spectral-norm.c -o spectral-norm.bin --math32 -lndos -m

zsdcc/classic
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 spectral-norm.c -o spectral-norm.bin -lmath48 -lndos -m
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 spectral-norm.c -o spectral-norm.bin --math32 -lndos -m

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks spectral-norm.bin -x specral-norm.map -start TIMER_START -end TIMER_STOP -counter 9999999999

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


Z88DK January 3, 2022
zsdcc #12555 / classic c library / math32
5910 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 9756176827
time @ 4MHz  = 9756176827 / 4*10^6 = 40 min 39 sec


Z88DK April 20, 2020
sccz80 / classic c library / genmath
4137 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 14688455657
time @ 4MHz  = 14688455657 / 4*10^6 = 61 min 12 sec


Z88DK July 4, 2021
sccz80 / classic c library / math32
5875 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 9718997187
time @ 4MHz  = 9718997187 / 4*10^6 = 40 min 29 sec


Z88DK January 3, 2022
sccz80 / classic c library / MBF32
4703 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6306469660
time @ 4MHz  = 6306469660 / 4*10^6 = 26 min 16 sec


Z88DK December 12, 2022
sccz80 / classic c library / 8085 / MBF32
4604 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6237494435
time @ 4MHz  = 6237494435 / 4*10^6 = 25 min 59 sec
