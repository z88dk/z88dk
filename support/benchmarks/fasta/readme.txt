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


CLASSIC Z80 / 8085 SUMMARY
==========================

Timer-bounded classic +test (main z80/8085). Full RESULT blocks:
z88dk-classic/readme.txt. N=1000.

Compiler | CPU  | Library | Ticks
---------|------|---------|-------------
sccz80   | z80  | math32  | 122_328_869  (Jul 2026)
sccz80   | 8085 | math32  | 186_704_695  (Jul 2026)
80cc     | z80  | math32  | 273_699_521  (Jul 2026 remeasure)
80cc     | 8085 | math32  | 530_674_851  (Jul 2026)
sccz80   | z80  | mbf32   | 165_734_164  (Jul 2026)
sccz80   | 8085 | mbf32   | 194_305_817  (Jul 2026)


RESULTS (full multi-toolchain archive)
======================================

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
Z88DK July 19, 2026
sccz80 / classic c library / MBF32
4796 bytes less page zero

cycle count  = 165734164
time @ 4MHz  = 165734164 / 4*10^6 = 41.43 sec

Microsoft 32-bit float implementation.

7.
Z88DK July 19, 2026
sccz80 / classic c library / math32
4582 bytes less page zero

cycle count  = 122328869
time @ 4MHz  = 122328869 / 4*10^6 = 30.58 sec

IEEE 32-bit float implementation.

8.
Z88DK July 20, 2026
sccz80 / classic c library / 8085 / math32
5639 bytes less page zero

cycle count  = 186704695
time @ 4MHz  = 186704695 / 4*10^6 = 46.68 sec

IEEE 32-bit float implementation (math32_8085).

9.
Z88DK July 20, 2026
80cc / classic c library / math32
6664 bytes less page zero

cycle count  = 273699521
time @ 4MHz  = 273699521 / 4*10^6 = 68.42 sec

IEEE 32-bit float implementation.

10.
Z88DK July 20, 2026
80cc / classic c library / 8085 / math32
8177 bytes less page zero

cycle count  = 530674851
time @ 4MHz  = 530674851 / 4*10^6 = 132.67 sec

IEEE 32-bit float implementation (math32_8085).

11.
Z88DK April 20, 2020
sccz80 / new c library
2998 bytes less page zero

cycle count  = 204281085
time @ 4MHz  = 204281085 / 4*10^6 = 51.07 sec

Internal 48-bit float implementation causes relative slowdown.

12.
Z88DK April 20, 2020
sccz80 / new c library / math32
3729 bytes less page zero

cycle count  = 136057141
time @ 4MHz  = 136057141 / 4*10^6 = 34.01 sec

IEEE 32-bit float implementation.

13.
Z88DK July 20, 2026
sccz80 / classic c library / 8085 / MBF32
4811 bytes less page zero

cycle count  = 194305817
time @ 4MHz  = 194305817 / 4*10^6 = 48.58 sec

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
