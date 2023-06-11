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


RESULTS
=======

1.
Z88DK April 28, 2021
zsdcc #12070 / new c library
4332 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2247889896
time @ 4MHz  = 2247889896 / 4*10^6 = 9 min 22 sec

Internal 48-bit float implementation causes relative slowdown.

2.
Z88DK March 18, 2017
zsdcc #9852 / classic c library
4739 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2254312065
time @ 4MHz  = 2254312065 / 4*10^6 = 9 min 24 sec

Internal 48-bit float implementation causes relative slowdown.

3.
IAR Z80 V4.06A
4084 bytes less small amount

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-6)

cycle count  = 2331516019
time @ 4MHz  = 2331516019 / 4*10^6 = 9 min 43 sec

4.
SDCC 4.2.0 Linux
7141 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 3163137393
time @ 4MHz  = 3163137393 / 4*10^6 = 13 min 11 sec

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

7.
Z88DK April 28, 2021
zsdcc #12070 / classic
5246 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 2253709929
time @ 4MHz  = 2253709929 / 4*10^6 = 9 min 23 sec

8.
Z88DK January 3, 2022
sccz80 / classic / math32
6052 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 995097719
time @ 4MHz  = 995097719 / 4*10^6 =  4 min 9 sec

IEEE 32-bit float implementation, accurate to 7 significant digits.

9.
Z88DK April 30, 2021
sccz80 / new c library / math32
5149 bytes less page zero

first number error : 5 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 754266702
time @ 4MHz  = 754266702 / 4*10^6 = 3 min 8 sec

IEEE 32-bit float implementation, accurate to 7 significant digits.

10.
Z88DK May 3, 2021
sccz80 / new / math16
3309 bytes less page zero

first number error : 5 * 10^(-4)
second number error: 5 * 10^(-2)

cycle count  = 357718801
time @ 4MHz  = 357718801 / 4*10^6 = 1 min 29 sec

IEEE 16-bit float implementation, accurate to 3 significant digits.

11.
Z88DK January 3, 2022
sccz80 / classic / MBF32
4989 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1848679330
time @ 4MHz  = 1848679330 / 4*10^6 =  7 min 42 sec

Microsoft 32-bit float implementation, accurate to 7 significant digits.

12.
Z88DK December 12, 2022
sccz80 / classic / 8085 / MBF32
4868 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1851095771
time @ 4MHz  = 1851095771 / 4*10^6 =  7 min 43 sec

Microsoft 32-bit float implementation, accurate to 7 significant digits.

13.
HITECH C MSDOS V780pl2
3736 bytes exact

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1600543903
time @ 4MHz  = 1600543903 / 4*10^6 = 6 min 40 sec

14.
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
