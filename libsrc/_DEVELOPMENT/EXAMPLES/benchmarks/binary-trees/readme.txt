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
measured.

=====================================

N=10

stretch tree of depth 11	 check: -1
2048	 trees of depth 4	 check: -2048
512	 trees of depth 6	 check: -512
128	 trees of depth 8	 check: -128
32	 trees of depth 10	 check: -32
long lived tree of depth 10	 check: -1

=====================================

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

When COMMAND is not defined, N=10.

MALLOC and FREE can be defined to replace the standard malloc/free with
another memory allocation implementation.


RESULTS
=======

1.
Z88DK March 2, 2017
zsdcc #9833 / new c library
2674 bytes less page zero not including heap

cycle count  = 132383340000
time @ 4MHz  = 132383340000 / 4*10^6 = 9 hrs 11 min 36 sec


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
