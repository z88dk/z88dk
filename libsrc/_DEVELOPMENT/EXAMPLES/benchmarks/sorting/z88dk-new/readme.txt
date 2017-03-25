CHANGES TO SOURCE CODE
======================

None.

VERIFY CORRECT RESULT
=====================

Z88DK's new c library contains a variety of sorting algorithms that
can be connected to qsort(), among them insertion sort, shell sort
and quicksort.  There is also an implementation of heapsort available
through the priority queue data type that cannot be connected to qsort.

The selection of sorting algorithm used by qsort is made in the
target's config_clib.m4 file.

To keep the number of test cases under control, we will only test
quicksort with its default settings (use middle pivot, enable
insertion sort for small partitions, enable equal items distribution).

Normally the libraries are built with shellsort as the default but
the implementation is nearly the same as for the classic c library
so times wouldn't differ too much from those results.  Instead
we'll test something else.

The target libraries have to be modified to connect quicksort to qsort().

Edit these two files:

z88dk/libsrc/_DEVELOPMENT/target/z80/config_clib.m4
z88dk/libsrc/_DEVELOPMENT/target/zx/config_clib.m4

At about line 469 in both files change "define(`__CLIB_OPT_SORT', 1)" to "define(`__CLIB_OPT_SORT', 2)".

Options below that line select middle pivot, insertion sort for small partitions and
equal items distribution.  Don't change any of those.

Open a shell or command prompt in z88dk/libsrc/_DEVELOPMENT and rebuild those two libraries:
"Winmake z80 zx" (windows) or "make TARGET=z80; make TARGET=zx" (non-windows).

To verify the correct result, compile for the zx target
and run on a spectrum emulator.

new/sccz80/quicksort
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=20 -clib=new -O2 sort.c -o sort-ran-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=20 -clib=new -O2 sort.c -o sort-ord-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=20 -clib=new -O2 sort.c -o sort-rev-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=20 -clib=new -O2 sort.c -o sort-equ-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=5000 -clib=new -O2 sort.c -o sort-ran-5000 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=5000 -clib=new -O2 sort.c -o sort-ord-5000 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=5000 -clib=new -O2 sort.c -o sort-rev-5000 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=5000 -clib=new -O2 sort.c -o sort-equ-5000 -create-app

new/zsdcc/quicksort
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-20 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=0 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-5000 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=1 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-5000 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=2 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-5000 -create-app
zcc +zx -vn -DPRINTF -DSTYLE=3 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-5000 -create-app

You can restore the default settings for the two libraries by undoing the edits of the
config files and rebuilding both libraries after timing is done.

TIMING
======

To time, the program was compiled for the generic z80 target so that
a binary ORGed at address 0 was produced.

This simplifies the use of TICKS for timing.

new/sccz80/quicksort
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=0 -DNUM=20 -clib=new -O2 sort.c -o sort-ran-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=1 -DNUM=20 -clib=new -O2 sort.c -o sort-ord-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=2 -DNUM=20 -clib=new -O2 sort.c -o sort-rev-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=3 -DNUM=20 -clib=new -O2 sort.c -o sort-equ-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=0 -DNUM=5000 -clib=new -O2 sort.c -o sort-ran-5000 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=1 -DNUM=5000 -clib=new -O2 sort.c -o sort-ord-5000 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=2 -DNUM=5000 -clib=new -O2 sort.c -o sort-rev-5000 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=3 -DNUM=5000 -clib=new -O2 sort.c -o sort-equ-5000 -m -create-app

new/zsdcc/quicksort
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=0 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=1 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=2 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=3 -DNUM=20 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-20 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=0 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ran-5000 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=1 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-ord-5000 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=2 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-rev-5000 -m -create-app
zcc +z80 -vn -startup=0 -DTIMER -DSTYLE=3 -DNUM=5000 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sort.c -o sort-equ-5000 -m -create-app

The map file was used to look up symbols "TIMER_START" and "TIMER_STOP".
On purpose these labels were placed so that their values would not vary
from compile to compile.  These address bounds were given to TICKS to
measure execution time.

A typical invocation of TICKS looked like this:

ticks sort-ran-20.bin -start 0385 -end 0398 -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

Program size is taken from the largest program for the 20-number case.
All programs are very close in size.

RESULT
======

Z88DK March 25, 2017
sccz80 / new c library / quicksort
1403 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          70502     0.0176 sec
sort-ord-20          28531     0.0071 sec
sort-rev-20          41986     0.0105 sec
sort-equ-20          41701     0.0104 sec

sort-ran-5000     56833460    14.2084 sec
sort-ord-5000     58340767    14.5852 sec
sort-rev-5000     44873477    11.2184 sec
sort-equ-5000     40106741    10.0267 sec


Z88DK March 25, 2017
zsdcc #9852 / new c library / quicksort
1303 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          68554     0.0171 sec
sort-ord-20          26210     0.0066 sec
sort-rev-20          38369     0.0096 sec
sort-equ-20          37122     0.0093 sec

sort-ran-5000     59078884    14.7697 sec
sort-ord-5000     50466524    12.6166 sec
sort-rev-5000     40192485    10.0481 sec
sort-equ-5000     32362669     8.0907 sec
