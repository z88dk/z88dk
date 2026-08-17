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

TIMER_START = 0x391
   0x189 (TIMER_START in binary-trees.sym) -
   0x183 (_main in binary-trees.sym) +
   0x38d (_main in binary-trees.map)

TIMER_STOP = 0x4f0
   0x2ea (TIMER_STOP in binary-trees.sym) -
   0x183 (_main in binary-trees.sym) +
   0x38d (_main in binary-trees.map)

SIZE = 7196 bytes
   3906 (_CODE in binary-trees.map) +
   3    (_HEADER0 in binary-trees.map) +
   3    (_HEADER1 in binary-trees.map) +
   3    (_HEADER2 in binary-trees.map) +
   3    (_HEADER3 in binary-trees.map) +
   3    (_HEADER4 in binary-trees.map) +
   3    (_HEADER5 in binary-trees.map) +
   3    (_HEADER6 in binary-trees.map) +
   3    (_HEADER7 in binary-trees.map) +
   16   (_HEADER8 in binary-trees.map) +
   3177 (_HOME in binary-trees.map) +
   40   (_GSINIT in binary-trees.map) +
   1    (_GSFINAL in binary-trees.map) +
   32   (_DATA in binary-trees.map)

The invocation of TICKS looked like this:

z88dk-ticks binary-trees.bin -start 0391 -end 04f0 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.6.0 #16608 Linux
7196 bytes less page zero

cycle count  = 193466493
time @ 4MHz  = 193466493 / 4*10^6 = 48.37 sec
