FASTA
=====

http://benchmarksgame.alioth.debian.org/u64q/program.php?test=fasta&lang=gcc&id=1

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and any modified source code is present in
subdirectories.

When compiling fasta, several defines are possible:

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
measured.  The original benchmark calls for running with N=1000 and
the expected output can be found at:

http://benchmarksgame.alioth.debian.org/download/fasta-output.txt

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

When COMMAND is not defined, N=1000.


RESULTS
=======

1.
HITECH C CPM V309-15
5638 bytes exact

cycle count  = 189901647
time @ 4MHz  = 189901647 / 4*10^6 = 47.4754 sec

2.
IAR Z80 V4.06A
6041 bytes less small amount

cycle count  = 223805149
time @ 4MHz  = 223805149 / 4x10^6 = 55.95 sec

3.
Z88DK April 20, 2020
zsdcc #11566 / new c library
3171 bytes less page zero

cycle count  = 245055005
time @ 4MHz  = 245055005 / 4*10^6 = 61.26 sec

Internal 48-bit float implementation causes relative slowdown.

4.
Z88DK April 20, 2020
zsdcc #11566 / classic c library
3583 bytes less page zero

cycle count  = 248331410
time @ 4MHz  = 248331410 / 4*10^6 = 62.08 sec

Internal 48-bit float implementation causes relative slowdown.

5.
SDCC 4.2.0 Linux
5835 bytes less page zero

cycle count  = 373202979
time @ 4MHz  = 373202979 / 4*10^6 = 93.30 sec

Large size & slow speed largely due to float implementation in C.

6.
Z88DK January 3, 2022
sccz80 / classic c library / MBF32
4823 bytes less page zero

cycle count  = 165102454
time @ 4MHz  = 165102454 / 4*10^6 = 41.27 sec

Microsoft 32-bit float implementation.

7.
Z88DK April 20, 2020
sccz80 / classic c library / math32
3978 bytes less page zero

cycle count  = 136057474
time @ 4MHz  = 136057474 / 4*10^6 = 34.01 sec

IEEE 32-bit float implementation.

8.
Z88DK April 20, 2020
sccz80 / new c library
2998 bytes less page zero

cycle count  = 204281085
time @ 4MHz  = 204281085 / 4*10^6 = 51.07 sec

Internal 48-bit float implementation causes relative slowdown.

9.
Z88DK April 20, 2020
sccz80 / new c library / math32
3729 bytes less page zero

cycle count  = 136057141
time @ 4MHz  = 136057141 / 4*10^6 = 34.01 sec

IEEE 32-bit float implementation.

10.
Z88DK December 12, 2022
sccz80 / classic c library / 8085 / MBF32
4869 bytes less page zero

cycle count  = 206325540
time @ 4MHz  = 206325540 / 4*10^6 = 51.58 sec

Microsoft 32-bit float implementation.

DISQ.
HITECH C MSDOS V780pl2
4121 bytes exact

Disqualified due to incorrect results.


BENCHMARKS GAME COMMENTS
========================

Variance
--------

Please don't optimize the cumulative-probabilities lookup (for example, by using a scaling factor) or na�ve LCG arithmetic - those programs will not be accepted.

How to implement
----------------

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    generate DNA sequences, by copying from a given sequence

    generate DNA sequences, by weighted random selection from 2 alphabets

        convert the expected probability of selecting each nucleotide into cumulative probabilities

        match a random number against those cumulative probabilities to select each nucleotide (use linear search or binary search)

        use this na�ve linear congruential generator to calculate a random number each time a nucleotide needs to be selected (don't cache the random number sequence)

        IM = 139968
        IA = 3877
        IC = 29573
        Seed = 42

        Random (Max)
           Seed = (Seed * IA + IC) modulo IM
           = Max * Seed / IM

diff program output N = 1000 with this 10KB output file to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (25000000) to check program performance.
