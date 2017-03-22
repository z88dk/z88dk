BINARY-TREES
============

http://benchmarksgame.alioth.debian.org/u64q/program.php?test=binarytrees&lang=gcc&id=1

The purpose of this benchmark is to verify that malloc/free
function trouble free and to measure the speed of malloc/free
with allocations done in the context of constructing binary trees.

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and any modified source code is present in
subdirectories.

When compiling binary-trees, several defines are possible:

/*
 * COMMAND LINE DEFINES
 * 
 * -DSTATIC
 * Use static variables instead of locals.
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
 * MALLOC and FREE
 * Can be defined to replace malloc() and free().
 *
 */

STATIC can be optionally defined to improve performance.

All compiles are first checked for correctness by running the program
with PRINTF defined.  After correctness is verified, time should be
measured with PRINTF undefined so that execution time of printf is not
measured.  The original benchmark calls for running with N=10 but since
that takes a lot of time, timed runs will be done with N=8.

=====================================

N=10

stretch tree of depth 11	 check: -1
2048	 trees of depth 4	 check: -2048
512	 trees of depth 6	 check: -512
128	 trees of depth 8	 check: -128
32	 trees of depth 10	 check: -32
long lived tree of depth 10	 check: -1

N = 8

stretch tree of depth 9	 check: -1
512	 trees of depth 4	 check: -512
128	 trees of depth 6	 check: -128
32	 trees of depth 8	 check: -32
long lived tree of depth 8	 check: -1

=====================================

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

When COMMAND is not defined, N=8.


RESULTS
=======


1.
Z88DK March 18, 2017
zsdcc #9852 / classic c library
2910 bytes less page zero

cycle count  = 151251680
time @ 4MHz  = 151251680 / 4*10^6 = 37.81 sec

2.
Z88DK March 18, 2017
sccz80 / classic c library
2852 bytes less page zero

cycle count  = 159135288
time @ 4MHz  = 159135288 / 4*10^6 = 39.78 sec

3.
SDCC 3.6.5 #9852 (MINGW64)
8626 bytes less page zero

cycle count  = 203788182
time @ 4MHz  = 203788182 / 4*10^6 = 50.95 sec

Large size caused by float package implemented in C.

4.
HITECH C MSDOS V750
4121 bytes exact

cycle count  = 243708728
time @ 4MHz  = 243708728 / 4x10^6 = 60.93 seconds

5.
Z88DK March 18, 2017
zsdcc #9852 / new c library
2683 bytes less page zero

cycle count  = 6574398908
time @ 4MHz  = 6574398908 / 4*10^6 = 27 min 24 sec

Issue #113: https://github.com/z88dk/z88dk/issues/113
Library optimization for fast realloc causes slow free block search
when a thousand blocks are allocated in this benchmark.

6.
Z88DK March 18, 2017
sccz80 / new c library
2733 bytes less page zero

cycle count  = 6588490067
time @ 4MHz  = 6588490067 / 4*10^6 = 27 min 27 sec

Issue #113: https://github.com/z88dk/z88dk/issues/113
Library optimization for fast realloc causes slow free block search
when a thousand blocks are allocated in this benchmark.

7.
IAR Z80 V4.06A
4525 bytes less small amount

cycle count  = 7358336547
time @ 4MHz  = 7358336547 / 4x10^6 = 30 min 40 sec

IAR is likely implementing a heap similar to z88dk's new c library
where an emphasis is placed on the speed of realloc().

DQ.
HITECH C CPM V309
4165 bytes less cpm overhead

Disqualified for incorrect results.


BENCHMARKS GAME COMMENTS
========================

Background
----------

A simplistic adaptation of Hans Boehm's GCBench, which in turn was adapted from a benchmark by John Ellis and Pete Kovac.

Thanks to Christophe Troestler and Einar Karttunen for help with this benchmark.


Variance
--------

Use default GC, use per node allocation or use a library memory pool.

As a practical matter, the myriad ways to tune GC will not be accepted.

As a practical matter, the myriad ways to custom allocate memory will not be accepted.

Please don't implement your own custom "arena" or "memory pool" or "free list" - they will not be accepted.


The work
--------

The work is to create binary trees - composed only of tree nodes all the way down-to depth 0, before any of those nodes are GC'd - using at-minimum the number of allocations of Jeremy Zerfas's C program. Don't optimize away the work.


How to implement
----------------

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    define a tree node class and methods, a tree node record and procedures, or an algebraic data type and functions, or…

    allocate a binary tree to 'stretch' memory, check it exists, and deallocate it

    allocate a long-lived binary tree which will live-on while other trees are allocated and deallocated

    allocate, walk, and deallocate many bottom-up binary trees

        allocate a tree

        walk the tree nodes, checksum the node items (and maybe deallocate the node)

        deallocate the tree 

    check that the long-lived binary tree still exists 

diff program output N = 10 with this 1KB output file to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (20) to check program performance. 
