CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

To verify correct results, compile for the zx spectrum target and
run in a spectrum emulator.

classic/sccz80/8085/MBF32
zcc +cpm -clib=8085 -vn -O2 -DSTATIC -DPRINTOUT whetstone.c -o whetstone --math-mbf32 -lndos -create-app

classic/sccz80/genmath : 40 bit mantissa
zcc +zx -vn -O2 -DSTATIC -DPRINTOUT whetstone.c -o whetstone -lm -lndos -create-app

classic/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +zx -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DPRINTOUT whetstone.c -o whetstone -lmath48 -lndos -create-app

(These compile settings were found to give the best results).

Compiles matched expected results exactly.

TIMING
======

To time, the program was compiled for the generic z80 target where
possible so that a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

classic/sccz80/8085/MBF32
zcc +test -clib=8085 -vn -O2 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin --math-mbf32 -lndos -m

classic/sccz80/genmath : 40 bit mantissa
zcc +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin -lm -lndos -m

classic/sccz80/MBF32 : 24 bit mantissa
zcc +test -vn -O2 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin --math-mbf32 -lndos -m

classic/80cc/MBF32 : 24 bit mantissa
zcc +test -compiler=80cc -vn -O2 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin --math-mbf32 -lndos -m

classic/80cc/8085/MBF32 : 24 bit mantissa
zcc +test -clib=8085 -compiler=80cc -vn -O2 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin --math-mbf32 -lndos -m

classic/zsdcc/math48 : 40 bit mantissa internal, 24 bit mantissa presented by compiler
zcc +test -vn -compiler=sdcc -SO3 --max-allocs-per-node200000 -DSTATIC -DTIMER -D__Z88DK whetstone.c -o whetstone.bin -lmath48 -lndos -m

Note: 80cc + --math32 builds but does not reach TIMER_STOP in a usable
time (skipped; do not publish). Use --math-mbf32 for 80cc whetstone.

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
These address bounds were given to TICKS to measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks whetstone.bin -x whetstone.map -start TIMER_START -end TIMER_STOP -counter 9999999999

For 8085 binaries add -m8085.

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Z88DK July 19, 2026
classic/sccz80/8085/MBF32
Microsoft 32-bit math 24 bit mantissa + 8 bit exponent
5959 bytes less page zero

cycle count  = 548321291
time @ 4MHz  = 548321291 / 4x10^6 = 137.0803 seconds
KWIPS        = 100*10*1 / 137.0803 = 7.2950
MWIPS        = 7.2950 / 1000 = 0.0072950


Z88DK January 3, 2022
classic/sccz80/genmath
40 bit mantissa + 8 bit exponent
6411 bytes less page zero

cycle count  = 1284172870
time @ 4MHz  = 1284172870 / 4x10^6 = 321.0432 seconds
KWIPS        = 100*10*1 / 320.8179 = 3.1148
MWIPS        = 3.1148 / 1000 = 0.0031148


Z88DK January 3, 2022
classic/zsdcc #12555/math48
40 bit mantissa + 8 bit exponent internal, 24 bit mantissa + 8 bit exponent exposed by compiler
7064 bytes less page zero

cycle count  = 917739704
time @ 4MHz  = 917739704 / 4x10^6 = 229.4349 seconds
KWIPS        = 100*10*1 / 230.1954 = 4.3585
MWIPS        = 4.3585 / 1000 = 0.0043585


Z88DK July 19, 2026
classic/sccz80/MBF32
Microsoft 32-bit math 24 bit mantissa + 8 bit exponent
6206 bytes less page zero

cycle count  = 544395320
time @ 4MHz  = 544395320 / 4x10^6 = 136.0988 seconds
KWIPS        = 100*10*1 / 136.0988 = 7.3476
MWIPS        = 7.3476 / 1000 = 0.0073476


Z88DK July 20, 2026
classic/80cc/MBF32
Microsoft 32-bit math 24 bit mantissa + 8 bit exponent
10122 bytes less page zero

cycle count  = 558782473
time @ 4MHz  = 558782473 / 4x10^6 = 139.6956 seconds
KWIPS        = 100*10*1 / 139.6956 = 7.1584
MWIPS        = 7.1584 / 1000 = 0.0071584


Z88DK July 20, 2026
classic/80cc/8085/MBF32
Microsoft 32-bit math 24 bit mantissa + 8 bit exponent
9670 bytes less page zero

cycle count  = 561486320
time @ 4MHz  = 561486320 / 4x10^6 = 140.3716 seconds
KWIPS        = 100*10*1 / 140.3716 = 7.1240
MWIPS        = 7.1240 / 1000 = 0.0071240

8085+MBF32 -> 78.2 Seconds. (historical host measurement)
8085+AM9511 ->30.4 Seconds. (historical host measurement)
