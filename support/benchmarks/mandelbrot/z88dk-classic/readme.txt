CHANGES TO SOURCE CODE
======================

For the sccz80 compile, variable "limit" in main() cannot be made static.

When built with --math16 (__MATH_MATH16), floating types use _Float16.
Mandelbrot coordinates stay well within the half exponent range.

COMPILATION
===========

Compilation:

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 mandelbrot.c -o mandelbrot.bin -lm -lndos -m

classic/sccz80/math32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math32 -lndos -m

classic/sccz80/math16
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math16 -lndos -m

classic/sccz80/8085/math32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math32 -lndos -m

classic/sccz80/8085/math16
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math16 -lmath32_8085 -lndos -m

classic/80cc/math32
zcc +test -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math32 -lndos -m

classic/80cc/8085/math32
zcc +test -clib=8085 -compiler=80cc -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math32 -lndos -m

classic/sccz80/8085/MBF32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=all mandelbrot.c -o mandelbrot.bin --math-mbf32 -lndos -m

classic/zsdcc
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -compiler=sdcc -SO3 --max-allocs-per-node200000 mandelbrot.c -o mandelbrot.bin -lmath48 -lndos -m

TIMING & VERIFICATION
=====================

With PRINTF undefined the program will write the 480-byte result into memory
at address 0xc000.  TICKS will be invoked such that it dumps the memory
contents of the 64k virtual machine at the end so that those 480 bytes
can be extracted and compared to the golden result.  The memory dump produced
consists of the current state of the 64k of memory followed by a block
holding current cpu state.

The map files generated from the compiles above were used to look up symbols
"TIMER_START" and "TIMER_STOP".  These address bounds were given to TICKS to
measure execution time.

A typical invocation of TICKS looked like this:

z88dk-ticks mandelbrot.bin -x mandelbrot.map -start TIMER_START -end TIMER_STOP -counter 999999999999 -output verify.bin

For 8085 binaries add -m8085.

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

To verify, extract the 480 bytes at address 0xc000 from "verify.bin":

z88dk-appmake +extract -b verify.bin -s 0xc000 -l 480 -o image.bin

Compare the contents of "image.bin" to "image-golden.bin" in the same directory.
The pixels around the edge of the mandelbrot set can vary somewhat depending
on math library precision so if there are differences, the two images may have
to be compared visually.  This can be done on a zx spectrum emulator by loading
the images to address 16384 to see a visual representation.

RESULT
======

Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic
2771 bytes less page zero

cycle count  = 3727334560
time @ 4MHz  = 3727334560 / 4*10^6 =  15 min 32 sec


Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic / math32
3857 bytes less page zero

cycle count  = 1301251782
time @ 4MHz  = 1301251782 / 4*10^6 =  5 min 25 sec


Z88DK April 28, 2021
sccz80 / classic
2693 bytes less page zero

cycle count  = 3596657568
time @ 4MHz  = 3596657568 / 4*10^6 = 14 min 59 sec


Z88DK August 15, 2026
sccz80 / classic / math32
3780 bytes less page zero

cycle count  = 1031176011
time @ 4MHz  = 1031176011 / 4*10^6 =  4 min 18 sec


Z88DK August 15, 2026
sccz80 / classic / 8085 / math32
4494 bytes less page zero

cycle count  = 2041768834
time @ 4MHz  = 2041768834 / 4*10^6 =  8 min 30 sec

(opt with sqr(): 899712336 ticks, 4660 bytes.)


Z88DK August 15, 2026
80cc / classic / math32
4171 bytes less page zero

cycle count  = 1113832378
time @ 4MHz  = 1113832378 / 4*10^6 =  4 min 38 sec


Z88DK August 15, 2026
80cc / classic / 8085 / math32
4883 bytes less page zero

cycle count  = 2061364665
time @ 4MHz  = 2061364665 / 4*10^6 =  8 min 35 sec


Z88DK July 19, 2026
sccz80 / classic / 8085 / MBF32
3397 bytes less page zero

cycle count  = 1805825674
time @ 4MHz  = 1805825674 / 4*10^6 =  7 min 31 sec


Z88DK August 10, 2026
sccz80 / classic / math16
3234 bytes less page zero

cycle count  = 789222173
time @ 4MHz  = 789222173 / 4*10^6 =  3 min 17 sec

IEEE 16-bit half-float implementation (math16).


Z88DK August 10, 2026
sccz80 / classic / 8085 / math16
3178 bytes less page zero

cycle count  = 969324571
time @ 4MHz  = 969324571 / 4*10^6 =  4 min  2 sec

IEEE 16-bit half-float implementation (math16_8085).
