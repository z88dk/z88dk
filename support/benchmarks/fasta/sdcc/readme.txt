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
makebin -p fasta.ihx fasta.bin

TIMER_START = 0x54b
   0x356 (TIMER_START in fasta.sym) -
   0x356 (_main in fasta.sym) +
   0x560 (_main in fasta.map)

TIMER_STOP = 0x598
   0x3a3 (TIMER_STOP in fasta.sym) -
   0x356 (_main in fasta.sym) +
   0x560 (_main in fasta.map)

SIZE = 6027 bytes
   2491 (_CODE in fasta.map) +
   3    (_HEADER0 in fasta.map) +
   3    (_HEADER1 in fasta.map) +
   3    (_HEADER2 in fasta.map) +
   3    (_HEADER3 in fasta.map) +
   3    (_HEADER4 in fasta.map) +
   3    (_HEADER5 in fasta.map) +
   3    (_HEADER6 in fasta.map) +
   3    (_HEADER7 in fasta.map) +
   16   (_HEADER8 in fasta.map) +
   3164 (_HOME in fasta.map) +
   97   (_INITIALIZER in fasta.map) +
   58   (_GSINIT in fasta.map) +
   1    (_GSFINAL in fasta.map) +
   79   (_DATA in fasta.map) +
   97   (_INITIALIZED in fasta.map)

The invocation of TICKS looked like this:

z88dk-ticks fasta.bin -start 054b -end 0598 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 4.6.0 #16608 Linux
6027 bytes less page zero

cycle count  = 414019207
time @ 4MHz  = 414019207 / 4*10^6 = 103.50 sec
