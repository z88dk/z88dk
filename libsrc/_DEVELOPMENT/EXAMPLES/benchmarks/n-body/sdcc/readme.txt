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
The resulting "n-body.com" file can be run in a cpm emulator to verify results.

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

TIMING
======

Change back to the main directory.

sdcc -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 n-body.c
hex2bin n-body.ihx

TIMER_START = 0x111d
   0xf13 (TIMER_START in n-body.sym) -
   0xf0b (_main in n-body.sym) +
   0x1115 (_main in n-body.map)

TIMER_STOP = 0x117c
   0xf72 (TIMER_STOP in n-body.sym) -
   0xf0b (_main in n-body.sym) +
   0x1115 (_main in n-body.map)

SIZE = 9233 bytes
   0x15db (_CODE in n-body.map) +
   0x0003 (_HEADER0 in n-body.map) +
   0x0002 (_HEADER1 in n-body.map) +
   0x0002 (_HEADER2 in n-body.map) +
   0x0002 (_HEADER3 in n-body.map) +
   0x0002 (_HEADER4 in n-body.map) +
   0x0002 (_HEADER5 in n-body.map) +
   0x0002 (_HEADER6 in n-body.map) +
   0x0002 (_HEADER7 in n-body.map) +
   0x000c (_HEADER8 in n-body.map) +
   0x0ca7 (_HOME in n-body.map) +
   0x008c (_INITIALIZER in n-body.map) +
	0x000f (_GSINIT in n-body.map) +
   0x0001 (_GSFINAL in n-body.map) +
   0x004a (_DATA in n-body.map) +
   0x008c (_INITIALIZED in n-body.map)

The invocation of TICKS looked like this:

ticks n-body.bin -start 111d -end 117c -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

SDCC 3.6.5 #9852 (MINGW64)
9233 bytes less page zero

first number error : 1 * 10^(-7)
second number error: 1 * 10^(-4)

cycle count  = 5306393684
time @ 4MHz  = 5306393684 / 4*10^6 = 22 min 07 sec
