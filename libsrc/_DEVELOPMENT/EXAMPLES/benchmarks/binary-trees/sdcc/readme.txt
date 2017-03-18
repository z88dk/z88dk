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

After "include <math.h>" add:

#define pow(a,b)  powf(a,b)

Add file "heap.s" to create a 20k heap.

Change "iterations = pow(2, maxDepth - depth + minDepth);"
to: "iterations = pow(2, maxDepth - depth + minDepth) + 0.5;"

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "bt.com" file can be run in a cpm emulator to verify results.

TIMING
======

Change back to the main directory.
Run Winmake.bat or execute the shell commands listed there.

TIMER_START = 0x39a
   0x190 (TIMER_START in binary-trees.sym) -
   0x188 (_main in binary-trees.sym) +
   0x392 (_main in binary-trees.map)

TIMER_STOP = 0x55d
   0x353 (TIMER_STOP in binary-trees.sym) -
   0x188 (_main in binary-trees.sym) +
   0x392 (_main in binary-trees.map)

SIZE = 8626 bytes
   0x11e1 (_CODE in binary-trees.map) +
   0x0003 (_HEADER0 in binary-trees.map) +
   0x0002 (_HEADER1 in binary-trees.map) +
   0x0002 (_HEADER2 in binary-trees.map) +
   0x0002 (_HEADER3 in binary-trees.map) +
   0x0002 (_HEADER4 in binary-trees.map) +
   0x0002 (_HEADER5 in binary-trees.map) +
   0x0002 (_HEADER6 in binary-trees.map) +
   0x0002 (_HEADER7 in binary-trees.map) +
   0x000c (_HEADER8 in binary-trees.map) +
   0x0f81 (_HOME in binary-trees.map) +
	0x0012 (_GSINIT in binary-trees.map) +
   0x0001 (_GSFINAL in binary-trees.map) +
   0x0020 (_DATA in binary-trees.map)

The invocation of TICKS looked like this:

ticks bt.bin -start 039a -end 055d -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9852 (MINGW64)
8626 bytes less page zero

cycle count  = 203788182
time @ 4MHz  = 203788182 / 4*10^6 = 50.95 sec
