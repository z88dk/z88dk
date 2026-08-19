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


CLASSIC Z80 / 8085 SUMMARY
==========================

Timer-bounded classic +test (main z80/8085). Full RESULT blocks:
z88dk-classic/readme.txt. w=h=60.

Compiler | CPU  | Library | Ticks
---------|------|---------|----------------
sccz80   | z80  | math16  |   789_222_173 (Aug 10, 2026)
sccz80   | 8085 | math16  | 969_324_571 (Aug 10, 2026)
sccz80   | z80  | math32  | 1_031_176_011 (Aug 15, 2026)
zsdcc    | z80  | math32  | 1_301_251_782 (Aug 16, 2026)
sccz80   | 8085 | math32  | 2_041_768_834 (Aug 15, 2026)
80cc     | z80  | math32  | 1_314_554_468 (Aug 19, 2026)
80cc     | 8085 | math32  | 1_988_563_544 (Aug 19, 2026)
sccz80   | 8085 | mbf32   | 1_805_825_674  (Jul 2026)


RESULTS (full multi-toolchain archive)
======================================

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
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library
1921 bytes less page zero

cycle count  = 3731890506
time @ 4MHz  = 3731890506 / 4*10^6 =  15 min 33 sec

Internal 48-bit float implementation causes relative slowdown.

4.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library
2771 bytes less page zero

cycle count  = 3727334560
time @ 4MHz  = 3727334560 / 4*10^6 =  15 min 32 sec

Internal 48-bit float implementation causes relative slowdown.

5.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library / math32
3857 bytes less page zero

cycle count  = 1301251782
time @ 4MHz  = 1301251782 / 4*10^6 =  5 min 25 sec

IEEE 32-bit float implementation (truncated high-half 32×32).

6.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / math32
3007 bytes less page zero

cycle count  = 1324037732
time @ 4MHz  = 1324037732 / 4*10^6 =  5 min 31 sec

IEEE 32-bit float implementation.

6b.
Z88DK August 15, 2026
sccz80 / new c library / math32
2940 bytes less page zero

cycle count  = 1049525678
time @ 4MHz  = 1049525678 / 4*10^6 =  4 min 22 sec

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
SDCC 4.6.0 #16608 Linux
4288 bytes less page zero

cycle count  = 7175307472
time @ 4MHz  = 7175307472 / 4*10^6 = 29 min 54 sec

Slow speed largely due to float implementation in C.

10.
Z88DK August 15, 2026
sccz80 / classic c library / math32
3780 bytes less page zero

cycle count  = 1031176011
time @ 4MHz  = 1031176011 / 4*10^6 =  4 min 18 sec

IEEE 32-bit float implementation.
(Truncated high-half 32×32 mantissa mul.)

11.
Z88DK August 15, 2026
sccz80 / classic c library / 8085 / math32
4494 bytes less page zero

cycle count  = 2041768834
time @ 4MHz  = 2041768834 / 4*10^6 =  8 min 30 sec

IEEE 32-bit float implementation (math32_8085).
(opt with sqr(): 899712336 ticks, 4660 bytes.)

12.
Z88DK August 19, 2026
80cc / classic c library / math32
4764 bytes less page zero

cycle count  = 1314554468
time @ 4MHz  = 1314554468 / 4*10^6 =  5 min 29 sec

IEEE 32-bit float implementation.

13.
Z88DK August 19, 2026
80cc / classic c library / 8085 / math32
4842 bytes less page zero

cycle count  = 1988563544
time @ 4MHz  = 1988563544 / 4*10^6 =  8 min 17 sec

IEEE 32-bit float implementation (math32_8085).

14.
Z88DK August 10, 2026
sccz80 / new c library / math16
2404 bytes less page zero

cycle count  =  789885425
time @ 4MHz  = 789885425 / 4*10^6 =  3 min 17 sec

IEEE 16-bit float implementation.

15.
Z88DK July 19, 2026
sccz80 / classic c library / 8085 / MBF32
3397 bytes less page zero

cycle count  = 1805825674
time @ 4MHz  = 1805825674 / 4*10^6 =  7 min 31 sec

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
