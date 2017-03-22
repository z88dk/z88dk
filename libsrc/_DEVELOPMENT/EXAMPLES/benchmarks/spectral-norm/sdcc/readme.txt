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

After "#include <math.h>" add "#define sqrt sqrtf"

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "spectral.com" file can be run in a cpm emulator to verify results.

error: 5 * 10^(-6)

TIMING
======

Change back to the main directory.

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 spectral-norm.c
hex2bin spectral-norm.ihx

TIMER_START = 0x4a0
   0x296 (TIMER_START in spectral-norm.sym) -
   0x289 (_main in spectral-norm.sym) +
   0x493 (_main in spectral-norm.map)

TIMER_STOP = 0x63c
   0x432 (TIMER_STOP in spectral-norm.sym) -
   0x289 (_main in spectral-norm.sym) +
   0x493 (_main in spectral-norm.map)

SIZE = 7495 bytes
   0x0a9d (_CODE in spectral-norm.map) +
   0x0003 (_HEADER0 in spectral-norm.map) +
   0x0002 (_HEADER1 in spectral-norm.map) +
   0x0002 (_HEADER2 in spectral-norm.map) +
   0x0002 (_HEADER3 in spectral-norm.map) +
   0x0002 (_HEADER4 in spectral-norm.map) +
   0x0002 (_HEADER5 in spectral-norm.map) +
   0x0002 (_HEADER6 in spectral-norm.map) +
   0x0002 (_HEADER7 in spectral-norm.map) +
   0x000c (_HEADER8 in spectral-norm.map) +
   0x0db9 (_HOME in spectral-norm.map) +
	0x000f (_GSINIT in spectral-norm.map) +
   0x0001 (_GSFINAL in spectral-norm.map) +
   0x04c4 (_DATA in spectral-norm.map)

The invocation of TICKS looked like this:

ticks spectral-norm.bin -start 04a0 -end 063c -counter 999999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9852 (MINGW64)
7495 bytes less page zero

error: 5 * 10^(-6)

cycle count  = 20543308237
time @ 4MHz  = 20543308237 / 4*10^6 = 85 min 36 sec
