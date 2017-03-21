PI.C
====

Computes pi to 800 decimal places, testing 32-bit integer math
as it does so.

The computation can make good use of ldiv() but not all compilers
supply this function so the program is written in two forms with
and without ldiv() for comparison purposes.

Original Source Code:
https://crypto.stanford.edu/pbc/notes/pi/code.html

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and that modified source code is present in
subdirectories.

The performance metric is time to complete in minutes and seconds.

/*
 * COMMAND LINE DEFINES
 * 
 * -DSTATIC
 * Use static variables instead of locals.
 *
 * -DPRINTF
 * Enable printf.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points.
 *
 */

STATIC can be optionally defined in order to increase the compiler's
performance.

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

All compiles are first checked for correctness by running the program
with PRINTF defined.  After correctness is verified, time should be
measured with PRINTF undefined so that execution time of printf is not
measured.  It is sufficient to recognize that pi is probably correct
if it leads with 3.141592653589793...

For a timed run, the program is compiled and simulated by TICKS.  TICKS
must be given a start address to start timing and a stop address to stop
timing.  In Z88DK compiles these show up in the map file.  Other compilers'
output may have to be disassembled to locate the correct address range.

The output of TICKS is a cycle count.  To convert to time in seconds:

Execution_Time = CYCLE_COUNT / FCPU
where FCPU = clock frequency of Z80 in Hz.


RESULTS - PI.C (NO LDIV)
========================

1.
Z88DK March 2, 2017
sccz80 / new c library / fast int math
9018 bytes less page zero

cycle count  = 1708903088
time @ 4MHz  = 1708903088 / 4*10^6 = 7 min 07 sec

2.
Z88DK March 2, 2017
zsdcc #9833 / new c library / fast int math
8997 bytes less page zero

cycle count  = 1739403552
time @ 4MHz  = 1739403552 / 4*10^6 = 7 min 15 sec

3.
Z88DK March 2, 2017
sccz80 / new c library / small int math
6269 bytes less page zero

cycle count  = 5246791210
time @ 4MHz  = 5246791210 / 4*10^6 = 21 min 52 sec

4.
Z88DK March 2, 2017
zsdcc #9833 / new c library / small int math
6246 bytes less page zero

cycle count  = 5278798872
time @ 4MHz  = 5278798872 / 4*10^6 = 22 min 00 sec

5.
Z88DK March 18, 2017
zsdcc #9852 / classic c library
6484 bytes less page zero

cycle count  = 5377063339
time @ 4MHz  = 5377063339 / 4*10^6 = 22 min 24 sec

6.
Z88DK March 18, 2017
sccz80 / classic c library
6387 bytes less page zero

cycle count  = 5391508326
time @ 4MHz  = 5391508326 / 4*10^6 = 22 min 29 sec

7.
HITECH C MSDOS V750
6337 bytes exact

cycle count  = 5520768427
time @ 4MHz  = 5520768427 / 4x10^6 = 23 min 00 sec

8.
HITECH C CPM V309
6793 bytes less cpm overhead

cycle count  = 5531933581
time @ 4MHz  = 5531933581 / 4*10^6 = 23 min 03 sec

9.
SDCC 3.6.5 #9842 (MINGW64)
6844 bytes less page zero

cycle count  = 8700157418
time @ 4MHz  = 8700157418 / 4*10^6 = 36 min 15 sec

SDCC implements its 32-bit math in C.

10.
IAR Z80 V4.06A
6789 bytes less small amount

cycle count  = 8762223085
time @ 4MHz  = 8762223085 / 4*10^6 = 36 min 31 sec

It looks like IAR implements its 32-bit math in C.


RESULTS - PI_LDIV.C (LDIV USED)
===============================

1.
Z88DK March 2, 2017
sccz80 / new c library / fast int math
9131 bytes less page zero

cycle count  = 1313857712
time @ 4MHz  = 1313857712 / 4*10^6 = 5 min 28 sec

2.
Z88DK March 2, 2017
zsdcc #9833 / new c library / fast int math
9097 bytes less page zero

cycle count  = 1328865976
time @ 4MHz  = 1328865976 / 4*10^6 = 5 min 32 sec

3.
Z88DK March 2, 2017
sccz80 / new c library / small int math
6382 bytes less page zero

cycle count  = 3810732458
time @ 4MHz  = 3810732458 / 4*10^6 = 15 min 53 sec

4.
Z88DK March 2, 2017
zsdcc #9833 / new c library / small int math
6348 bytes less page zero

cycle count  = 3827247920
time @ 4MHz  = 3827247920 / 4*10^6 = 15 min 57 sec

5.
HITECH C MSDOS V750
6486 bytes exact

cycle count  = 5884356227
time @ 4MHz  = 5884356227 / 4x10^6 = 24 min 31 sec

It looks like HTC implements ldiv() as two separate divisions.

6.
IAR Z80 V4.06A
7006 bytes less small amount

cycle count  = 8799503282
time @ 4MHz  = 8799503282 / 4*10^6 = 36 min 40 sec

It looks like IAR implements ldiv() as two separate divisions.
It looks like IAR implements its 32-bit math in C.
