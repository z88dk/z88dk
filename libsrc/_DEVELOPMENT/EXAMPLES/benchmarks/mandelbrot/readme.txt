MANDELBROT
==========

http://benchmarksgame.alioth.debian.org/u64q/program.php?test=mandelbrot&lang=gcc&id=2

This program generates a black and white image of the mandelbrot set with size given
by w(idth) and (h)eight in pixels.

The output is in the form of a whole number of ceil(w/8) bytes horizontally by
h rows vertically with each bit representing a pixel.  The result has been displayed
on the zx spectrum target by slightly modifiying the program.

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and any modified source code is present in
subdirectories.

When compiling mandelbrot, several defines are possible:

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
 * Enable reading w and h from the command line.
 *
 */

You can define PRINTF to have the output printed out as bytes.  These
bytes will represent 8 pixels and will not display properly.  The
original benchmark expects these bytes to be redirected to a file
from where they can be diffed with the golden result to verify the
program is working.

Instead here we will run the program without PRINTF and have it write
the bytes into memory which will be extracted and compared with the
expected result.

The original benchmark calls for running with w=h=200 and the expected
output can be found at:

http://benchmarksgame.alioth.debian.org/download/mandelbrot-output.txt

The zx spectrum compile with zsdcc was found to be correct for the
default values of w and h (60 for both) so its output is taken as
golden for the verifications.

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

When COMMAND is not defined, w=h=60 so that a 60x60 portrait of the
mandelbrot set is produced.  This maps to a ceil(60/8)*60 = 480 byte
block of memory to hold the result.


RESULTS
=======

1.
HITECH C CPM V309
1872 bytes less cpm overhead

cycle count  = 1852698998
time @ 4MHz  = 1852698998 / 4*10^6 = 7 min 43 sec

Very fast float library but only accurate for */+-

2.
IAR Z80 V4.06A
2333 bytes less small amount

cycle count  = 3256695469
time @ 4MHz  = 3256695469 / 4x10^6 = 13 min 34 sec

3.
Z88DK March 18, 2017
zsdcc #9852 / new c library
1953 bytes less page zero

cycle count  = 3734872448
time @ 4MHz  = 3734872448 / 4*10^6 = 15 min 34 sec

Internal 48-bit float implementation causes relative slowdown.

4.
Z88DK March 18, 2017
zsdcc #9852 / classic c library
2303 bytes less page zero

cycle count  = 3781297645
time @ 4MHz  = 3781297645 / 4*10^6 = 15 min 45 sec

Internal 48-bit float implementation causes relative slowdown.

5.
Z88DK March 18, 2017
sccz80 / new c library
2013 bytes less page zero

cycle count  = 3853108866
time @ 4MHz  = 3853108866 / 4*10^6 = 16 min 03 sec

48-bit float implementation causes relative slowdown.

6.
Z88DK March 18, 2017
sccz80 / classic c library
2148 bytes less page zero

cycle count  = 4409687319
time @ 4MHz  = 4409687319 / 4*10^6 = 18 min 22 sec

48-bit float implementation causes relative slowdown.

7.
SDCC 3.6.5 #9852 (MINGW64)
5218 bytes less page zero

cycle count  = 10863431873
time @ 4MHz  = 10863431873 / 4*10^6 = 45 min 16 sec

Large size & slow speed largely due to float implementation in C.

DQ.
HITECH C MSDOS V750
1526 bytes exact

Disqualified due to incorrect results.
HTCv750 does not have a functioning float library.


BENCHMARKS GAME COMMENTS
========================

Background
----------

MathWorld: Mandelbrot Set
http://mathworld.wolfram.com/MandelbrotSet.html

Thanks to Greg Buchholz for suggesting this task.

How to implement
----------------

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    plot the Mandelbrot set [-1.5-i,0.5+i] on an N-by-N bitmap. Write output byte-by-byte in portable bitmap format. 

cmp program output N = 200 with this 5KB output file to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (16000) to check program performance. 
