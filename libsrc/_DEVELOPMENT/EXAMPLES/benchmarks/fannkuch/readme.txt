fannkuch-redux description
--------------------------

http://benchmarksgame.alioth.debian.org/u64q/program.php?test=fannkuchredux&lang=gcc&id=1

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and any modified source code is present in
subdirectories.

When compiling fannkuch, several defines are possible:

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
 * -DINLINE
 * Compiler supports inline functions.
 *
 * -DCOMMAND
 * Enable reading of N from the command line.
 *
 */

STATIC can be optionally defined to improve performance.

All compiles are first checked for correctness by running the program
with PRINTF defined.  After correctness is verified, time should be
measured with PRINTF undefined so that execution time of printf is not
measured.

=====================================

228
Pfannkuchen(7) = 16

=====================================

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

When COMMAND is not defined, the benchmark runs with N=7.


RESULTS
=======

1.
HITECH C MSDOS V750
716 bytes exact

cycle count  = 49858382
time @ 4MHz  = 49858382 / 4x10^6 = 12.46 sec

2.
Z88DK March 18, 2017
zsdcc #9852 / new c library
1082 bytes less page zero

cycle count  = 53329244
time @ 4MHz  = 53329244 / 4*10^6 = 13.33 sec

3.
HITECH C CPM V309
1218 bytes less cpm overhead

cycle count  = 56667034
time @ 4MHz  = 56667034 / 4*10^6 = 14.17 sec

4.
IAR Z80 V4.06A
1347 bytes less small amount

cycle count  = 56708022
time @ 4MHz  = 56708022 / 4x10^6 = 14.18 sec

5.
Z88DK March 18, 2017
zsdcc #9852 / classic c library
1386 bytes less page zero

cycle count  = 63620883
time @ 4MHz  = 63620883 / 4*10^6 = 15.91 sec

6.
SDCC 3.6.5 #9852 (MINGW64)
1196 bytes less page zero

cycle count  = 67174167
time @ 4MHz  = 67174167 / 4*10^6 = 16.79 sec

7.
Z88DK March 18, 2017
sccz80 / new c library
1173 bytes less page zero

cycle count  = 89043877
time @ 4MHz  = 89043877 / 4*10^6 = 22.26 sec

8.
Z88DK March 18, 2017
sccz80 / classic c library
1236 bytes less page zero

cycle count  = 90501905
time @ 4MHz  = 90501905 / 4*10^6 = 22.63 sec



Background
----------

The fannkuch benchmark is defined by programs in Performing Lisp Analysis of the FANNKUCH Benchmark, Kenneth R. Anderson and Duane Rettig. FANNKUCH is an abbreviation for the German word Pfannkuchen, or pancakes, in analogy to flipping pancakes. The conjecture is that the maximum count is approximated by n*log(n) when n goes to infinity.


How to implement
----------------

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    Take a permutation of {1,...,n}, for example: {4,2,1,5,3}.

    Take the first element, here 4, and reverse the order of the first 4 elements: {5,1,2,4,3}.

    Repeat this until the first element is a 1, so flipping won't change anything more: {3,4,2,1,5}, {2,4,3,1,5}, {4,2,3,1,5}, {1,3,2,4,5}.

    Count the number of flips, here 5.

    Keep a checksum

        checksum = checksum + (if permutation_index is even then flips_count else -flips_count)

        checksum = checksum + (toggle_sign_-1_1 * flips_count) 

    Do this for all n! permutations, and record the maximum number of flips needed for any permutation. 

diff program output N = 7 with this output file to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (12) to check program performance. 
