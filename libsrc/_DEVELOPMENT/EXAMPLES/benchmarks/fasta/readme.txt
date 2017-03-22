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
HITECH C CPM V309
4056 bytes less cpm overhead

cycle count  = 188751954
time @ 4MHz  = 188751954 / 4*10^6 = 47.19 sec

Very fast float library but only accurate for +-*/

2.
IAR Z80 V4.06A
6041 bytes less small amount

cycle count  = 223805149
time @ 4MHz  = 223805149 / 4x10^6 = 55.95 sec

3.
Z88DK March 18, 2017
zsdcc #9852 / new c library
3144 bytes less page zero

cycle count  = 251825519
time @ 4MHz  = 251825519 / 4*10^6 = 62.96 sec

Internal 48-bit float implementation causes relative slowdown.

4.
Z88DK March 18, 2017
zsdcc #9852 / classic c library
3519 bytes less page zero

cycle count  = 256212331
time @ 4MHz  = 256212331 / 4*10^6 = 64.05 sec

Internal 48-bit float implementation causes relative slowdown.

5.
SDCC 3.6.5 #9852 (MINGW64)
6947 bytes less page zero

cycle count  = 488970702
time @ 4MHz  = 488970702 / 4*10^6 = 122.24 sec

Large size & slow speed largely due to float implementation in C.
Bugged -DSTATIC prevents potentially faster version from compiling.

DQ.
HITECH C MSDOS V750
4121 bytes exact

Disqualified due to incorrect results.
HTC V750 does not have a functioning float library.


BENCHMARKS GAME COMMENTS
========================

Variance
--------

Please don't optimize the cumulative-probabilities lookup (for example, by using a scaling factor) or naïve LCG arithmetic - those programs will not be accepted.

How to implement
----------------

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    generate DNA sequences, by copying from a given sequence

    generate DNA sequences, by weighted random selection from 2 alphabets

        convert the expected probability of selecting each nucleotide into cumulative probabilities

        match a random number against those cumulative probabilities to select each nucleotide (use linear search or binary search)

        use this naïve linear congruential generator to calculate a random number each time a nucleotide needs to be selected (don't cache the random number sequence)

        IM = 139968
        IA = 3877
        IC = 29573
        Seed = 42
         	
        Random (Max)
           Seed = (Seed * IA + IC) modulo IM
           = Max * Seed / IM

diff program output N = 1000 with this 10KB output file to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (25000000) to check program performance.
