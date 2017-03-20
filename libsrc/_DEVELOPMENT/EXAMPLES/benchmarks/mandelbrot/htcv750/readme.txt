CHANGES TO SOURCE CODE
======================

None.

COMPILATION
===========

Using IDE HPDZ.EXE make a new project containing MANDEL.C.
Choose ROM target and max optimizations with global optimization = 9.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC
Build the program, ignoring warnings as they come up.

TIMING & VERIFICATION
=====================

With PRINTF undefined the program will write the 480-byte result into memory
at address 0xc000.  TICKS will be invoked such that it dumps the memory
contents of the 64k virtual machine at the end so that those 480 bytes
can be extracted and compared to the golden result.  The memory dump produced
consists of the current state of the 64k of memory followed by a block
holding current cpu state.

Program size from the IDE dialog is: 1440 (ROM) + 86 (RAM) = 1526 bytes.
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks mandel.bin -start 0105 -end 0380 -counter 999999999999 -output verify.bin

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

To verify, extract the 480 bytes at address 0xc000 from "verify.bin":

appmake +extract -b verify.bin -s 0xc000 -l 480 -o image.bin

Compare the contents of "image.bin" to "image-golden.bin" in the same directory.
The pixels around the edge of the mandelbrot set can vary somewhat depending
on math library precision so if there are differences, the two images may have
to be compared visually.  This can be done on a zx spectrum emulator by loading
the images to address 16384 to see a visual representation.

PROGRAM FAILS DUE TO INCORRECT OUTPUT.


RESULT
======

HITECH C MSDOS V750
1526 bytes exact

Disqualified due to incorrect results.
