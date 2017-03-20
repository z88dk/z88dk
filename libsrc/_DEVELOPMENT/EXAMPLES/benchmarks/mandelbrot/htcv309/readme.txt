CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

COMPILATION
===========

Compilation:
C -V -LF -DSTATIC -O -MMANDEL.MAP MANDEL.C

TIMING & VERIFICATION
=====================

With PRINTF undefined the program will write the 480-byte result into memory
at address 0xc000.  TICKS will be invoked such that it dumps the memory
contents of the 64k virtual machine at the end so that those 480 bytes
can be extracted and compared to the golden result.  The memory dump produced
consists of the current state of the 64k of memory followed by a block
holding current cpu state.

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0x6f2 + 0x32 + 0x2c = 1872 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o ma0.bin
appmake +inject -b ma0.bin -i MANDEL.COM -s 256 -o ma.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks ma.bin -start 0146 -end 0393 -counter 99999999999 -output verify.bin

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

HITECH C CPM V309
1872 bytes less cpm overhead

cycle count  = 1852698998
time @ 4MHz  = 1852698998 / 4*10^6 = 7 min 43 sec
