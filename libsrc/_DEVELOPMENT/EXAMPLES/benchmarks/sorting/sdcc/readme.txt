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

After "include <stdlib.h>" add:

extern void qsort(void *base,unsigned int nmemb,unsigned int size,void *compar);

There is no qsort() in sdcc's c library.  Add qsort.c to the compile.

VERIFY CORRECT RESULT
=====================

Verification is done by targeting CPM.  A very simple putchar + getchar
calling into BDOS is provided in cpm.s and a generic qsort.c is also supplied.

Change to the "verify" directory and compile by running "Winmake.bat".
The resulting com files can be run in a cpm emulator to verify results.

TIMING
======

Change back to the main directory.
Run Winmake.bat to create all the test binaries.

The timer labels were placed purposely so that they would
change little from compile to compile.  Addresses found
for one of the compiles:

TIMER_START = 0x3f0
   0x023 (TIMER_START in sort-ran-20.sym) -
   0x03c (_main in sort-ran-20.sym) +
   0x409 (_main in sort-ran-20.map)

TIMER_STOP = 0x407
   0x03b (TIMER_STOP in sort-ran-20.sym) -
   0x03c (_main in sort-ran-20.sym) +
   0x409 (_main in sort-ran-20.map)

The largest NUM=20 case was used to report size.
(This is the sort-ran-20 program).
	
SIZE = 1080 bytes
   0x03c9 (_CODE in sort-ran-20.map) +
   0x0003 (_HEADER0 in sort-ran-20.map) +
   0x0002 (_HEADER1 in sort-ran-20.map) +
   0x0002 (_HEADER2 in sort-ran-20.map) +
   0x0002 (_HEADER3 in sort-ran-20.map) +
   0x0002 (_HEADER4 in sort-ran-20.map) +
   0x0002 (_HEADER5 in sort-ran-20.map) +
   0x0002 (_HEADER6 in sort-ran-20.map) +
   0x0002 (_HEADER7 in sort-ran-20.map) +
   0x000c (_HEADER8 in sort-ran-20.map) +
	0x0023 (_GSINIT in sort-ran-20.map) +
   0x0001 (_GSFINAL in sort-ran-20.map) +
   0x002e (_DATA in sort-ran-20.map)

TICKS was invoked for each binary and typically
looked like this:

ticks sort-ran-20.bin -start 03f0 -end 0407 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

Not compile yet - some kind of error.

SDCC 3.6.5 #9852 (MINGW64)
1080 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20         113965     0.0285 sec
sort-ord-20          99399     0.0248 sec
sort-rev-20         116849     0.0292 sec
sort-equ-20         184267     0.0461 sec

sort-ran-5000     77526792    19.3817 sec
sort-ord-5000     61119685    15.2799 sec
sort-rev-5000     67382381    16.8456 sec
sort-equ-5000         did not finish

qsort not present in library, instead supplied from the internet.
Naive implementation stumbles on equal items edge case.
