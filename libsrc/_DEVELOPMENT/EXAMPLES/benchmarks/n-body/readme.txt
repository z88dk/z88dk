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
Z88DK June 28, 2020
zsdcc #11690 / new
4309 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2247439592
time @ 4MHz  = 2247439592 / 4*10^6 = 9 min 22 sec

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
SDCC 3.6.5 #9852 (MINGW64)
9233 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 5306393684
time @ 4MHz  = 5306393684 / 4*10^6 = 22 min 07 sec

Slow speed & large size due to float implementation in C.

5.
Z88DK April 20, 2020
sccz80 / classic c library
3814 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 3624577433
time @ 4MHz  = 3624577433 / 4*10^6 = 15 min 06 sec

Internal 48-bit float implementation causes relative slowdown.

6.
Z88DK June 28, 2020
sccz80 / new c library
3608 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2372283755
time @ 4MHz  = 2372283755 / 4*10^6 = 9 min 53 sec

Internal 48-bit float implementation causes relative slowdown.

7.
Z88DK April 20, 2020
zsdcc #11566 / classic
4770 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-8)

cycle count  = 2253531346
time @ 4MHz  = 2253531346 / 4*10^6 = 9 min 23 sec

8.
Z88DK June 28, 2020
sccz80 / new / math32
5264 bytes less page zero

first number error : 5 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 1025105884
time @ 4MHz  = 1025105884 / 4*10^6 = 4 min 16 sec

IEEE 32-bit float implementation, accurate to 7 significant digits.

9.
Z88DK June 28, 2020
sccz80 / new / math16
3227 bytes less page zero

first number error : 5 * 10^(-4)
second number error: 5 * 10^(-2)

cycle count  = 384230543
time @ 4MHz  = 384230543 / 4*10^6 = 1 min 36 sec

IEEE 16-bit float implementation, accurate to 3 significant digits.

DQ.
HITECH C CPM V309
???? bytes less cpm overhead

Unable to compile.

DQ.
HITECH C MSDOS V750
? bytes exact

Disqualified due to incorrect results.
HTC v750 does not have a functioning float library.


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
