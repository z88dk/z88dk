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


RESULTS
=======

1.
HITECH C CPM V309-15
2135 bytes exact

error: 1 * 10^(-6)

cycle count  = 6790499956
time @ 4MHz  = 6790499956 / 4*10^6 = 28 min 18 sec

2.
Z88DK April 20, 2020
zsdcc #11566 / new c library
3358 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8628617805
time @ 4MHz  = 8628617805 / 4*10^6 = 35 min 57 sec

Internal 48-bit float implementation causes relative slowdown.

3.
Z88DK April 30, 2021
zsdcc #12250 / classic c library / math48
3984 bytes less page zero

error: 2 * 10^(-9)

cycle count  = 8617785182
time @ 4MHz  = 8617785182 / 4*10^6 = 35 min 54 sec

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
Z88DK January 3, 2022
zsdcc #12555 / classic c library / math32
5910 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 9756176827
time @ 4MHz  = 9756176827 / 4*10^6 = 40 min 39 sec

8.
Z88DK July 4, 2021
zsdcc #12419 / new c library / math32
5453 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 9947615066
time @ 4MHz  = 9947615066 / 4*10^6 = 41 min 27 sec

9.
SDCC 4.2.0 Linux
6013 bytes less page zero

error: 5 * 10^(-6)

cycle count  = 15739496039
time @ 4MHz  = 15739496039 / 4*10^6 = 65 min 35 sec

Slow speed & large size due to float implementation in C.

10.
Z88DK January 3, 2022
sccz80 / classic c library / MBF32
4703 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6306469660
time @ 4MHz  = 6306469660 / 4*10^6 = 26 min 16 sec

11.
Z88DK December 12, 2022
sccz80 / classic c library / 8085 / MBF32
4604 bytes less page zero

error: 2 * 10^(-7)

cycle count  = 6237494435
time @ 4MHz  = 6237494435 / 4*10^6 = 25 min 59 sec

12.
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
