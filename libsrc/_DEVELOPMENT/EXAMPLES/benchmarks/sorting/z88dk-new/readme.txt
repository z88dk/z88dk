CHANGES TO SOURCE CODE
======================

2022: Added extra ticks-trap code before return from main to finish with
status code in ticks. (the return from main in new-lib z80 target does
end with `di : halt : jr $` infinite loop)

And optimised the newlib implementation itself to avoid divu call for every
new middle-pivot selection.

And added (to satisfy my own curiosity) extra hard-coded hand-written assembly
example using size=2 and inlined compare for uint16_t case (ignoring
the compare function), it's hidden under invalid OPT_SORT=3 option.

VERIFY CORRECT RESULT
=====================

Z88DK's new c library contains a variety of sorting algorithms that
can be connected to qsort(), among them insertion sort, shell sort
and quicksort.  There is also an implementation of heapsort available
through the priority queue data type that cannot be connected to qsort.

The selection of sorting algorithm used by qsort is made in the
target's config_clib.m4 file.

The Makefile argument SORT_OPTS is used to select configurations to test and
benchmark, be aware the full test takes about 10-20min to run on PC
(the default Makefile does only two main configurations, uncomment the long
one to do all).

Normally the libraries are built with shellsort as the default but
the implementation is nearly the same as for the classic c library
so times wouldn't differ too much from those results.

The performance values in this readme.txt are for quicksort option (2+0xc).

The updated version of example builds the sort implementation for each test
case from .asm source, using the per case config (doesn't need full library
rebuild), but for qsort() use in own projects mind the library configuration.

To build libraries for particular configuration, edit these two files:

z88dk/libsrc/_DEVELOPMENT/target/z80/config_clib.m4
z88dk/libsrc/_DEVELOPMENT/target/zx/config_clib.m4

At about line 469 in both files change "define(`__CLIB_OPT_SORT', 1)" and
"define(`__CLIB_OPT_SORT_QSORT', 0x0c)" to your liking.

Open a shell or command prompt in z88dk/libsrc/_DEVELOPMENT and rebuild those two libraries:
"Winmake z80 zx" (windows) or "make TARGET=z80; make TARGET=zx" (non-windows).

To verify the correct result, compile for the zx target
and run on a spectrum emulator.

new/sccz80/quicksort
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=20 -clib=new -O2 sort.c -o sort-zx -create-app

new/zsdcc/quicksort
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-zx -create-app

(valid values for STYLE: 0,1,2,3 and NUM used in test 20,5000)

You can restore the default settings for the two libraries by undoing the edits of the
config files and rebuilding both libraries.

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

Building of per-case configuration is automated in Makefile, building binary
and running it twice, first with full `main` verifying order of result (test
does check only if previous value is less/equal than next one, doesn't verify
the values are part of original array). Second run times the code between
labels "TIMER_START" and "TIMER_STOP".

The Makefile target benchmark.txt will produce log with all combinations,
producing number of cycles or "FAIL" in case the resulting order is wrong.

A typical invocation of TICKS looked like this:

z88dk-ticks sort-ran-20.bin -x sort-ran-20.map -start TIMER_START -end TIMER_STOP -counter 999999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

Program size is taken from the largest program for the 20-number case.
All programs are very close in size.

RESULT
======

Z88DK March 21, 2022
new c library / sccz80 19388-38ebdf3b7-20220307 / __CLIB_OPT_SORT = 2, __CLIB_OPT_SORT_QSORT = 0xc
1464 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          68544     0.0171 sec
sort-ord-20          25896     0.0065 sec
sort-rev-20          39139     0.0098 sec
sort-equ-20          27242     0.0068 sec

sort-ran-5000     54653916    13.6635 sec
sort-ord-5000     55753490    13.9384 sec
sort-rev-5000     42224444    10.5561 sec
sort-equ-5000     36069168     9.0173 sec


Z88DK March 21, 2022
new c library / zsdcc 4.2.0 #13131 / __CLIB_OPT_SORT = 2, __CLIB_OPT_SORT_QSORT = 0xc
1391 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          62688     0.0157 sec
sort-ord-20          23578     0.0059 sec
sort-rev-20          35845     0.0090 sec
sort-equ-20          24948     0.0062 sec

sort-ran-5000     50916067    12.7290 sec
sort-ord-5000     47359197    11.8398 sec
sort-rev-5000     38926382     9.7316 sec
sort-equ-5000     28291376     7.0728 sec
