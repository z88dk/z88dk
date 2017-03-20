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
 * Enable reading w and h from the command line.
 *
 */

You can define PRINTF to have the output printed out as bytes.  These
bytes will represent 8 pixels and will not displat properly.  The
original benchmark expects these bytes to be redirected to a file
from where they can be diffed with the golden result to verify the
program is working.

Instead here we will run the program without PRINTF and have it write
the bytes into memory which will be extracted and compared with the
expected result.

The original benchmark calls for running with N=1000 and the expected
output can be found at:

http://benchmarksgame.alioth.debian.org/download/fasta-output.txt

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
Z88DK March 18, 2017
zsdcc #9852 / new
1953 bytes less page zero

cycle count  = 3734872448
time @ 4MHz  = 3734872448 / 4*10^6 = 15 min 34 sec

2.
Z88DK March 18, 2017
sccz80 / new
2013 bytes less page zero

cycle count  = 3853108866
time @ 4MHz  = 3853108866 / 4*10^6 = 16 min 03 sec


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
