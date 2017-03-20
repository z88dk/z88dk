CHANGES TO SOURCE CODE
======================

For the sccz80 compile, variable "limit" in main() cannot be made static.

COMPILATION
===========

Compilation:

new/sccz80
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -O2 -clib=new mandelbrot.c -o mandelbrot -lm -m -pragma-include:zpragma.inc -create-app

new/zsdcc
zcc +z80 -vn -DSTATIC -DTIMER -startup=0 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 mandelbrot.c -o mandelbrot -lm -m -pragma-include:zpragma.inc -create-app

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

ticks mandelbrot.bin -start 0495 -end 075d -counter 999999999999 -output verify.bin

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

To verify, extract the 480 bytes at address 0xc000 from "verify.bin":

appmake +extract -b verify.bin -s 0xc000 -l 480 -o image.bin

Compare the contents of "image.bin" to "image-golden.bin" in the same directory.
The pixels around the edge of the mandelbrot set can vary somewhat depending
on math library precision so if there are differences, the two images may have
to be compared visually.  This can be done on a zx spectrum emulator by loading
the images to address 16384 to see a visual representation.

RESULT
======

Z88DK March 18, 2017
zsdcc #9852 / new
1953 bytes less page zero

cycle count  = 3734872448
time @ 4MHz  = 3734872448 / 4*10^6 = 15 min 34 sec


Z88DK March 18, 2017
sccz80 / new
2013 bytes less page zero

cycle count  = 3853108866
time @ 4MHz  = 3853108866 / 4*10^6 = 16 min 03 sec
