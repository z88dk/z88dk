SPECTRAL NORM
=============

http://benchmarksgame.alioth.debian.org/u64q/program.php?test=spectralnorm&lang=gcc&id=1

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and any modified source code is present in
subdirectories.

When compiling n-body, several defines are possible:

/*
 * COMMAND LINE DEFINES
 *
 * -DSTATIC
 * Make locals static.
 *
 * -DPRINTF
 * Enable printing of results.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points (Z88DK).
 *
 */

All compiles are first checked for correctness by running the program
with PRINTF defined.  After correctness is verified, time should be
measured with PRINTF undefined so that execution time of printf is not
measured.

=====================================

N=100

1.274219991

=====================================

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.


CLASSIC Z80 / 8085 SUMMARY
==========================

Timer-bounded classic +test (main z80/8085). Full RESULT blocks:
z88dk-classic/readme.txt. N=100.

Compiler | CPU  | Library | Ticks
---------|------|---------|-----------------
sccz80   | z80  | math16  | 2_531_057_653 (Aug 10, 2026)
sccz80   | 8085 | math16  | 3_438_830_098 (Aug 10, 2026)
sccz80   | z80  | math32  | 4_225_897_043 (Aug 15, 2026)
zsdcc    | z80  | math32  | 4_438_922_816 (Aug 16, 2026)
sccz80   | 8085 | math32  | 7_938_950_247 (Aug 15, 2026)
80cc     | z80  | math32  | 4_543_479_003 (Aug 19, 2026)
80cc     | 8085 | math32  | 7_866_270_332 (Aug 19, 2026)
sccz80   | z80  | mbf32   | 6_346_228_466   (Jul 2026)
sccz80   | 8085 | mbf32   | 6_227_757_878   (Jul 2026)


RESULTS (full multi-toolchain archive)
======================================

1.
HITECH C CPM V309-15
2135 bytes exact

error: 1 * 10^(-6)

cycle count  = 6790499956
time @ 4MHz  = 6790499956 / 4*10^6 = 28 min 18 sec

2.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library
3353 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8624203411
time @ 4MHz  = 8624203411 / 4*10^6 =  35 min 56 sec

Internal 48-bit float implementation causes relative slowdown.

3.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library / math48
3982 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8613814814
time @ 4MHz  = 8613814814 / 4*10^6 =  35 min 53 sec

Internal 48-bit float implementation causes relative slowdown.

4.
IAR Z80 V4.06A
3957 bytes less small amount

error: 1 * 10^(-6)

cycle count  = 8632065790
time @ 4MHz  = 8632065790 / 4*10^6 = 35 min 58 sec

5.
Z88DK April 20, 2020
sccz80 / new c library
3895 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8906227168
time @ 4MHz  = 8906227168 / 4*10^6 = 37 min 07 sec

48-bit float implementation causes relative slowdown.

6.
Z88DK April 20, 2020
sccz80 / classic c library
4137 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 14688455657
time @ 4MHz  = 14688455657 / 4*10^6 = 61 min 12 sec

48-bit float implementation causes relative slowdown.
[Issue #124](https://github.com/z88dk/z88dk/issues/124) Normalization is slow.

7.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library / math32
5899 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4438922816
time @ 4MHz  = 4438922816 / 4*10^6 =  18 min 30 sec

8.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / math32
5293 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4471074620
time @ 4MHz  = 4471074620 / 4*10^6 =  18 min 38 sec

8b.
Z88DK August 15, 2026
sccz80 / new c library / math32
5161 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4247660135
time @ 4MHz  = 4247660135 / 4*10^6 =  17 min 42 sec

9.
SDCC 4.6.0 #16608 Linux
6150 bytes less page zero

error: 5 * 10^(-6)

cycle count  = 18120604224
time @ 4MHz  = 18120604224 / 4*10^6 = 75 min 30 sec

Slow speed & large size due to float implementation in C.

10.
Z88DK August 15, 2026
sccz80 / classic c library / math32
5746 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4225897043
time @ 4MHz  = 4225897043 / 4*10^6 =  17 min 36 sec

11.
Z88DK August 15, 2026
sccz80 / classic c library / 8085 / math32
6705 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 7938950247
time @ 4MHz  = 7938950247 / 4*10^6 =  33 min  5 sec

12.
Z88DK August 19, 2026
80cc / classic c library / math32
6268 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 4543479003
time @ 4MHz  = 4543479003 / 4*10^6 =  18 min 56 sec

13.
Z88DK August 19, 2026
80cc / classic c library / 8085 / math32
6882 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 7866270332
time @ 4MHz  = 7866270332 / 4*10^6 =  32 min 47 sec

14.
Z88DK July 19, 2026
sccz80 / classic c library / MBF32
4705 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6346228466
time @ 4MHz  = 6346228466 / 4*10^6 = 26 min 27 sec

15.
Z88DK July 19, 2026
sccz80 / classic c library / 8085 / MBF32
4480 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6227757878
time @ 4MHz  = 6227757878 / 4*10^6 = 25 min 57 sec

16.
HITECH C MSDOS V780pl2
3780 bytes exact

error: 2 * 10^(-7)

cycle count  = 6780314927
time @ 4MHz  = 6780314927 / 4*10^6 = 28 min 15 sec


BENCHMARKS GAME COMMENTS
========================

Background
----------

MathWorld: "Hundred-Dollar, Hundred-Digit Challenge Problems", Challenge #3.

Thanks to Sebastien Loisel for suggesting this task.
How to implement

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    calculate the spectral norm of an infinite matrix A, with entries a11=1, a12=1/2, a21=1/3, a13=1/4, a22=1/5, a31=1/6, etc

    implement 4 separate functions / procedures / methods like the C# program
