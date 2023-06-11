CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

COMPILATION
===========

CC -V -N -OF -DSTATIC -DPRINTF MANDEL.C -LF

Run MANDEL.COM and verify correct output.

TIMING & VERIFICATION
=====================

CC -V -N -OF -DSTATIC -MMANDEL.MAP MANDEL.C -LF

With PRINTF undefined the program will write the 480-byte result into memory
at address 0xc000.  TICKS will be invoked such that it dumps the memory
contents of the 64k virtual machine at the end so that those 480 bytes
can be extracted and compared to the golden result.  The memory dump produced
consists of the current state of the 64k of memory followed by a block
holding current cpu state.

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0      9D9
            data          9D9      9D9      390
            bss           D69      D69       2E

SIZE = text + data + bss = 0x9D9 + 0x390 + 0x2E = 3479 bytes

z88dk-ticks MANDEL.COM -counter 99999999999 -output verify.bin

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

HITECH C CPM V309-15
3479 bytes exact

cycle count  = 1870290979
time @ 4MHz  = 1870290979 / 4*10^6 = 7 min 47 sec
