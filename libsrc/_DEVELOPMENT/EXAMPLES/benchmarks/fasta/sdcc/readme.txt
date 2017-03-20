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

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting "fasta.com" file can be run in a cpm emulator to verify results.

TIMING
======

Change back to the main directory.

sdcc -mz80 -DTIMER --max-allocs-per-node200000 fasta.c
hex2bin fasta.ihx

(The -DSTATIC compile is bugged under sdcc)

TIMER_START = 0x5e3
   0x3d9 (TIMER_START in fasta.sym) -
   0x3d1 (_main in fasta.sym) +
   0x5db (_main in fasta.map)

TIMER_STOP = 0x64c
   0x442 (TIMER_STOP in fasta.sym) -
   0x3d1 (_main in fasta.sym) +
   0x5db (_main in fasta.map)

SIZE = 6947 bytes
   0x0b7e (_CODE in fasta.map) +
   0x0003 (_HEADER0 in fasta.map) +
   0x0002 (_HEADER1 in fasta.map) +
   0x0002 (_HEADER2 in fasta.map) +
   0x0002 (_HEADER3 in fasta.map) +
   0x0002 (_HEADER4 in fasta.map) +
   0x0002 (_HEADER5 in fasta.map) +
   0x0002 (_HEADER6 in fasta.map) +
   0x0002 (_HEADER7 in fasta.map) +
   0x000c (_HEADER8 in fasta.map) +
   0x0e52 (_HOME in fasta.map) +
   0x0061 (_INITIALIZER in fasta.map) +
	0x0024 (_GSINIT in fasta.map) +
   0x0001 (_GSFINAL in fasta.map) +
   0x004f (_DATA in fasta.map) +
   0x0061 (_INITIALIZED in fasta.map)
	(heap not included)

The invocation of TICKS looked like this:

ticks fasta.bin -start 05e3 -end 064c -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9852 (MINGW64)
6947 bytes less page zero

cycle count  = 488970702
time @ 4MHz  = 488970702 / 4*10^6 = 122.24 sec
