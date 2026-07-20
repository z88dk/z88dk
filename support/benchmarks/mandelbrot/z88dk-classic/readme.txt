CHANGES TO SOURCE CODE
======================

For the sccz80 compile, variable "limit" in main() cannot be made static.

COMPILATION
===========

Compilation:

classic/sccz80
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O2 mandelbrot.c -o mandelbrot.bin -lm -lndos -m

classic/sccz80/math32
zcc +test -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math32 -lndos -m

classic/sccz80/8085/math32
zcc +test -clib=8085 -vn -DSTATIC -DTIMER -D__Z88DK -O3 --opt-code-speed=inlineints mandelbrot.c -o mandelbrot.bin --math32 -lndos -m

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

Z88DK April 28, 2021
zsdcc #12070 / classic
2891 bytes less page zero

cycle count  = 3766086833
time @ 4MHz  = 3766086833 / 4*10^6 = 15 min 41 sec


Z88DK April 30, 2021
zsdcc #12070 / classic / math32
4804 bytes less page zero

cycle count  = 1410662416
time @ 4MHz  = 1410662416 / 4*10^6 = 5 min 53 sec


Z88DK April 28, 2021
sccz80 / classic
2693 bytes less page zero

cycle count  = 3596657568
time @ 4MHz  = 3596657568 / 4*10^6 = 14 min 59 sec


Z88DK July 19, 2026
sccz80 / classic / math32
4717 bytes less page zero

cycle count  = 1152093641
time @ 4MHz  = 1152093641 / 4*10^6 =  4 min 48 sec


Z88DK July 19, 2026
sccz80 / classic / 8085 / math32
6325 bytes less page zero

cycle count  = 1403401196
time @ 4MHz  = 1403401196 / 4*10^6 =  5 min 51 sec


Z88DK July 20, 2026
80cc / classic / math32
5458 bytes less page zero

cycle count  = 1290571216
time @ 4MHz  = 1290571216 / 4*10^6 =  5 min 23 sec


Z88DK July 20, 2026
80cc / classic / 8085 / math32
6990 bytes less page zero

cycle count  = 2752742816
time @ 4MHz  = 2752742816 / 4*10^6 = 11 min 28 sec


Z88DK July 19, 2026
sccz80 / classic / 8085 / MBF32
3397 bytes less page zero

cycle count  = 1805825674
time @ 4MHz  = 1805825674 / 4*10^6 =  7 min 31 sec
