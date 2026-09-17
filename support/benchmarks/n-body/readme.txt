N-BODY
======

http://benchmarksgame.alioth.debian.org/u64q/program.php?test=nbody&lang=gcc&id=2

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
 * -DCOMMAND
 * Enable reading of N from the command line.
 *
 */

All compiles are first checked for correctness by running the program
with PRINTF defined.  After correctness is verified, time should be
measured with PRINTF undefined so that execution time of printf is not
measured.

=====================================

N=1000

-0.169075164
-0.169087605

=====================================

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

When COMMAND is not defined, N=1000.


CLASSIC Z80 / 8085 SUMMARY
==========================

Timer-bounded classic +test (main z80/8085). Full RESULT blocks:
z88dk-classic/readme.txt. N=1000.

Compiler | CPU  | Library | Ticks
---------|------|---------|----------------
sccz80   | z80  | math16  |   295_229_389 (Sep 17, 2026; DT=1e-1)
sccz80   | 8085 | math16  |   348_032_655 (Sep 17, 2026; DT=1e-1)
sccz80   | z80  | math32  |   808_246_253 (Sep 17, 2026)
zsdcc    | z80  | math32  |   860_188_405 (Sep 17, 2026)
sccz80   | 8085 | math32  | 1_488_228_803 (Sep 17, 2026)
sccz80   | z80  | mbf32   | 1_835_079_611  (Jul 2026)
sccz80   | 8085 | mbf32   | 1_849_800_062  (Jul 2026)
80cc     | z80  | math32 |   881_844_523 (Sep 17, 2026)
80cc     | 8085 | math32 |   1_476_931_107 (Sep 17, 2026)


RESULTS (full multi-toolchain archive)
======================================

1.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library
4186 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2245295168
time @ 4MHz  = 2245295168 / 4*10^6 =  9 min 21 sec

Internal 48-bit float implementation causes relative slowdown.

2.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library
4962 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 2243368504
time @ 4MHz  = 2243368504 / 4*10^6 =  9 min 21 sec

Internal 48-bit float implementation causes relative slowdown.

3.
IAR Z80 V4.06A
4084 bytes less small amount

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-6)

cycle count  = 2331516019
time @ 4MHz  = 2331516019 / 4*10^6 = 9 min 43 sec

4.
SDCC 4.6.0 #16608 Linux
7283 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 4361393645
time @ 4MHz  = 4361393645 / 4*10^6 = 18 min 10 sec

Slow speed & large size due to float implementation in C.

5.
Z88DK January 3, 2022
sccz80 / classic
4527 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 3659884553
time @ 4MHz  = 3659884553 / 4*10^6 = 15 min 15 sec

Internal 48-bit float implementation causes relative slowdown.

6.
Z88DK April 28, 2021
sccz80 / new c library
3363 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2376486525
time @ 4MHz  = 2376486525 / 4*10^6 = 9 min 53 sec

Internal 48-bit float implementation causes relative slowdown.

8.
Z88DK September 17, 2026
sccz80 / classic / math32
5897 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 2 * 10^(-6)

cycle count  = 808246253
time @ 4MHz  = 808246253 / 4*10^6 =  3 min 22 sec

IEEE 32-bit float implementation, accurate to 7 significant digits.
(Truncated high-half 32×32 mantissa mul; suite 16/16.)

Energy: -0.1690752 / -0.1690861 (N=1000).

8b.
Z88DK September 17, 2026
zsdcc 4.6.0 #16639 / classic / math32
6821 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 2 * 10^(-6)

cycle count  = 860188405
time @ 4MHz  = 860188405 / 4*10^6 =  3 min 35 sec

IEEE 32-bit float implementation (classic +test, -compiler=sdcc -SO3 --math32).

Energy: -0.1690752 / -0.1690861 (N=1000).

9.
Z88DK September 17, 2026
sccz80 / classic / 8085 / math32
6836 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 2 * 10^(-6)

cycle count  = 1488228803
time @ 4MHz  = 1488228803 / 4*10^6 =  6 min 12 sec

IEEE 32-bit float implementation (math32_8085), accurate to 7 significant digits.

Energy: -0.1690752 / -0.1690861 (N=1000).

9b.
Z88DK September 17, 2026
80cc / classic / math32
9385 bytes less page zero

cycle count  = 881844523
time @ 4MHz  = 881844523 / 4*10^6 =  3 min 40 sec

IEEE 32-bit float implementation.

9c.
Z88DK September 17, 2026
80cc / classic / 8085 / math32
8593 bytes less page zero

cycle count  = 1476931107
time @ 4MHz  = 1476931107 / 4*10^6 =  6 min  9 sec

IEEE 32-bit float implementation.

10.
Z88DK September 17, 2026
sccz80 / new c library / math32
5052 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 2 * 10^(-6)

cycle count  = 807783742
time @ 4MHz  = 807783742 / 4*10^6 =  3 min 22 sec

IEEE 32-bit float implementation, accurate to 7 significant digits.
(After sccz80 newlib math32 *_fastcall header remap; sqrt path correct.)

Energy: -0.1690752 / -0.1690861 (N=1000).

11.
Z88DK September 17, 2026
sccz80 / new / math16
3306 bytes less page zero

first number error : 5 * 10^(-4)
second number error: 5 * 10^(-2)

cycle count  = 295229389
time @ 4MHz  = 295229389 / 4*10^6 =  1 min 14 sec

IEEE 16-bit float implementation, accurate to 3 significant digits.

12.
Z88DK July 19, 2026
sccz80 / classic / MBF32
4956 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1835079611
time @ 4MHz  = 1835079611 / 4*10^6 =  7 min 39 sec

Microsoft 32-bit float implementation, accurate to 7 significant digits.

13.
Z88DK July 19, 2026
sccz80 / classic / 8085 / MBF32
4729 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1849800062
time @ 4MHz  = 1849800062 / 4*10^6 =  7 min 42 sec

Microsoft 32-bit float implementation, accurate to 7 significant digits.

14.
HITECH C MSDOS V780pl2
3736 bytes exact

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1600543903
time @ 4MHz  = 1600543903 / 4*10^6 = 6 min 40 sec

15.
HITECH C CPM V309-15
5633 bytes exact

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1594771948
time @ 4MHz  = 1594771948 / 4*10^6 = 6 min 38 sec


BENCHMARKS GAME COMMENTS
========================

Background
----------

Model the orbits of Jovian planets, using the same simple symplectic-integrator.

Thanks to Mark C. Lewis for suggesting this task.

Useful symplectic integrators are freely available, for example the HNBody Symplectic Integration Package.

How to implement
----------------

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    use the same simple symplectic-integrator - see the Java program.
