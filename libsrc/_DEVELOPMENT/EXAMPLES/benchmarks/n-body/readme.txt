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
Z88DK March 18, 2017
zsdcc #9852 / new c library
4191 bytes less page zero

first number error : 5 * 10^(-8)
second number error: 1 * 10^(-4)

cycle count  = 2244963926
time @ 4MHz  = 2244963926 / 4*10^6 = 9 min 21 sec

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
