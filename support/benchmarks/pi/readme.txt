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
Z88DK April 4, 2022
sccz80 / new c library / fast int math
9049 bytes less page zero

cycle count  = 1766815709
time @ 4MHz  = 1766815709 / 4*10^6 =  7 min 22 sec

2.
Z88DK April 4, 2022
zsdcc #13131 / new c library / fast int math
9049 bytes less page zero

cycle count  = 1736106244
time @ 4MHz  = 1736106244 / 4*10^6 =  7 min 14 sec

3.
Z88DK April 4, 2022
sccz80 / new c library / small int math
6340 bytes less page zero

cycle count  = 4028061102
time @ 4MHz  = 4028061102 / 4*10^6 = 16 min 47 sec

4.
Z88DK April 4, 2022
zsdcc #13131 / new c library / small int math
6299 bytes less page zero

cycle count  = 4011979932
time @ 4MHz  = 4011979932 / 4*10^6 = 16 min 43 sec

5.
Z88DK April 4, 2022
zsdcc #13131 / classic c library
7146 bytes less page zero

cycle count  = 4013954322
time @ 4MHz  = 4013954322 / 4*10^6 = 16 min 43 sec

6.
Z88DK April 4, 2022
sccz80 / classic c library
7154 bytes less page zero

cycle count  = 4028061102
time @ 4MHz  = 4028061102 / 4*10^6 = 16 min 47 sec

7.
HITECH C MSDOS V780pl2
6593 bytes exact

cycle count  = 5528979464
time @ 4MHz  = 5528979464 / 4x10^6 = 23 min 02 sec

8.
HITECH C CPM V309-15
8342 bytes exact

cycle count  = 5532347800
time @ 4MHz  = 5532347800 / 4*10^6 = 23 min 03 sec

9.
SDCC 4.2.0 Linux
6591 bytes less page zero

cycle count  = 6649404381
time @ 4MHz  = 6649404381 / 4*10^6 = 27 min 42 sec

SDCC implements its 32-bit math in C.

10.
IAR Z80 V4.06A
6789 bytes less small amount

cycle count  = 8762223085
time @ 4MHz  = 8762223085 / 4*10^6 = 36 min 31 sec

It looks like IAR implements its 32-bit math in C.

11.
Z88DK December 12, 2022
sccz80 / classic c library / 8085 CPU
7335 bytes less page zero

cycle count  = 7824146079
time @ 4MHz  = 7824146079 / 4*10^6 = 32 min 36 sec

RESULTS - PI_LDIV.C (LDIV USED)
===============================

1.
Z88DK April 4, 2022
sccz80 / new c library / fast int math
9139 bytes less page zero

cycle count  = 1358535133
time @ 4MHz  = 1358535133 / 4*10^6 =  5 min 39 sec

2.
Z88DK April 4, 2022
zsdcc #13131 / new c library / fast int math
9123 bytes less page zero

cycle count  = 1316559068
time @ 4MHz  = 1316559068 / 4*10^6 =  5 min 29 sec

3.
Z88DK April 4, 2022
sccz80 / new c library / small int math
6428 bytes less page zero

cycle count  = 2578767150
time @ 4MHz  = 2578767150 / 4*10^6 = 10 min 45 sec

4.
Z88DK April 4, 2022
zsdcc #13131 / new c library / small int math
6391 bytes less page zero

cycle count  = 2551419380
time @ 4MHz  = 2551419380 / 4*10^6 = 10 min 38 sec

5.
HITECH C MSDOS V780pl2
6728 bytes exact

cycle count  = 5892567264
time @ 4MHz  = 5892567264 / 4x10^6 = 24 min 33 sec

It looks like HTC implements ldiv() as two separate divisions.

6.
IAR Z80 V4.06A
7006 bytes less small amount

cycle count  = 8799503282
time @ 4MHz  = 8799503282 / 4*10^6 = 36 min 40 sec

It looks like IAR implements ldiv() as two separate divisions.
It looks like IAR implements its 32-bit math in C.
