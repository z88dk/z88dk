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
HITECH C CPM V309-15
3479 bytes exact

cycle count  = 1870290979
time @ 4MHz  = 1870290979 / 4*10^6 = 7 min 47 sec

2.
IAR Z80 V4.06A
2333 bytes less small amount

cycle count  = 3256695469
time @ 4MHz  = 3256695469 / 4x10^6 = 13 min 34 sec

3.
Z88DK April 28, 2021
zsdcc #12070 / new c library
1952 bytes less page zero

cycle count  = 3736214166
time @ 4MHz  = 3736214166 / 4*10^6 = 15 min 34 sec

Internal 48-bit float implementation causes relative slowdown.

4.
Z88DK April 28, 2021
zsdcc #12070 / classic c library
2891 bytes less page zero

cycle count  = 3766086833
time @ 4MHz  = 3766086833 / 4*10^6 = 15 min 41 sec

Internal 48-bit float implementation causes relative slowdown.

5.
Z88DK April 30, 2021
zsdcc #12070 / classic c library / math32
4804 bytes less page zero

cycle count  = 1410662416
time @ 4MHz  = 1410662416 / 4*10^6 = 5 min 53 sec

6.
Z88DK April 28, 2021
zsdcc #12070 / new c library / math32
3977 bytes less page zero

cycle count  = 1414728459
time @ 4MHz  = 1414728459 / 4*10^6 = 5 min 54 sec

IEEE 32-bit float implementation.

7.
Z88DK April 28, 2021
sccz80 / new c library
1809 bytes less page zero

cycle count  = 3266168305
time @ 4MHz  = 3266168305 / 4*10^6 = 13 min 36 sec

48-bit float implementation causes relative slowdown.

8.
Z88DK April 28, 2021
sccz80 / classic c library
2693 bytes less page zero

cycle count  = 3596657568
time @ 4MHz  = 3596657568 / 4*10^6 = 14 min 59 sec

48-bit float implementation causes relative slowdown.

9.
SDCC 4.2.0 Linux
3962 bytes less page zero

cycle count  = 4991827956
time @ 4MHz  = 4991827956 / 4*10^6 = 20 min 48 sec

Slow speed largely due to float implementation in C.

10.
Z88DK April 30, 2021
sccz80 / classic c library / math32
4559 bytes less page zero

cycle count  = 1142045217
time @ 4MHz  = 1142045217 / 4*10^6 =  4 min 45 sec

IEEE 32-bit float implementation.

11.
Z88DK May 3, 2021
sccz80 / new c library / math16
2050 bytes less page zero

cycle count  =  915024561
time @ 4MHz  =  915024561 / 4*10^6 =  3 min 48 sec

IEEE 16-bit float implementation.

12.
Z88DK January 5, 2022
sccz80 / classic c library / 8085 / MBF32
3457 bytes less page zero

cycle count  = 1806589346
time @ 4MHz  = 1806589346 / 4*10^6 =  7 min 32 sec

DISQ.
HITECH C MSDOS V780pl2
1679 bytes exact

Disqualified due to incorrect results.


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
