CHANGES TO SOURCE CODE
======================

Change:

#ifdef TIMER
   #define TIMER_START()       __asm__("TIMER_START:")
   #define TIMER_STOP()        __asm__("TIMER_STOP:")
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif

During compile these assembly labels will cause warnings about
z80instructionSize() failing.  This happens because the optimizer thinks
the labels are instructions.  These can be safely ignored.

COMPILATION
===========

Compilation:

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 mandelbrot.c
hex2bin mandelbrot.ihx

TIMING & VERIFICATION
=====================

With PRINTF undefined the program will write the 480-byte result into memory
at address 0xc000.  TICKS will be invoked such that it dumps the memory
contents of the 64k virtual machine at the end so that those 480 bytes
can be extracted and compared to the golden result.  The memory dump produced
consists of the current state of the 64k of memory followed by a block
holding current cpu state.

TIMER_START = 0x21f
   0x015 (TIMER_START in mandelbrot.sym) -
   0x000 (_main in mandelbrot.sym) +
   0x20a (_main in mandelbrot.map)

TIMER_STOP = 0x5ea
   0x3e0 (TIMER_STOP in mandelbrot.sym) -
   0x000 (_main in mandelbrot.sym) +
   0x20a (_main in mandelbrot.map)

SIZE = 5218 bytes
   0x0741 (_CODE in mandelbrot.map) +
   0x0003 (_HEADER0 in mandelbrot.map) +
   0x0002 (_HEADER1 in mandelbrot.map) +
   0x0002 (_HEADER2 in mandelbrot.map) +
   0x0002 (_HEADER3 in mandelbrot.map) +
   0x0002 (_HEADER4 in mandelbrot.map) +
   0x0002 (_HEADER5 in mandelbrot.map) +
   0x0002 (_HEADER6 in mandelbrot.map) +
   0x0002 (_HEADER7 in mandelbrot.map) +
   0x000c (_HEADER8 in mandelbrot.map) +
   0x0ca7 (_HOME in mandelbrot.map) +
   0x0002 (_INITIALIZER in mandelbrot.map) +
	0x0029 (_GSINIT in mandelbrot.map) +
   0x0001 (_GSFINAL in mandelbrot.map) +
   0x002f (_DATA in mandelbrot.map) +
   0x0002 (_INITIALIZED in mandelbrot.map)
	(heap not included)

The invocation of TICKS looked like this:

ticks mandelbrot.bin -start 021f -end 05ea -counter 999999999999 -output verify.bin

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

SDCC 3.6.5 #9852 (MINGW64)
5218 bytes less page zero

cycle count  = 10863431873
time @ 4MHz  = 10863431873 / 4*10^6 = 45 min 16 sec
