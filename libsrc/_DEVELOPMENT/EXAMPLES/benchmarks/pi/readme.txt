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
8999 bytes less page zero

cycle count  = 1696878309
time @ 4MHz  = 1696878309 / 4*10^6 =  7 min 04 sec

2.
Z88DK April 20, 2020
zsdcc #11566 / new c library / fast int math
8997 bytes less page zero

cycle count  = 1756864232
time @ 4MHz  = 1756864232 / 4*10^6 =  7 min 19 sec

3.
Z88DK April 20, 2020
sccz80 / new c library / small int math
6269 bytes less page zero

cycle count  = 4012440735
time @ 4MHz  = 4012440735 / 4*10^6 = 16 min 43 sec

4.
Z88DK April 20, 2020
zsdcc #11566 / new c library / small int math
6246 bytes less page zero

cycle count  = 4067517071
time @ 4MHz  = 4067517071 / 4*10^6 = 16 min 57 sec

5.
Z88DK April 20, 2020
zsdcc #11566 / classic c library
6600 bytes less page zero

cycle count  = 4169137078
time @ 4MHz  = 4169137078 / 4*10^6 = 17 min 22 sec

6.
Z88DK January 3, 2022
sccz80 / classic c library
7146 bytes less page zero

cycle count  = 4056462302
time @ 4MHz  = 4056462302 / 4*10^6 = 16 min 54 sec

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

11.
Z88DK January 5, 2022
sccz80 / classic c library / 8085 CPU
7310 bytes less page zero

cycle count  = 8565626880
time @ 4MHz  = 8565626880 / 4*10^6 = 35 min 41 sec

RESULTS - PI_LDIV.C (LDIV USED)
===============================

1.
Z88DK April 4, 2020
sccz80 / new c library / fast int math
9131 bytes less page zero

cycle count  = 1301832933
time @ 4MHz  = 1301832933 / 4*10^6 =  5 min 25 sec

2.
Z88DK April 4, 2020
zsdcc #11566 / new c library / fast int math
9097 bytes less page zero

cycle count  = 1339849656
time @ 4MHz  = 1339849656 / 4*10^6 =  5 min 35 sec

3.
Z88DK April 20, 2020
sccz80 / new c library / small int math
6400 bytes less page zero

cycle count  = 2576381983
time @ 4MHz  = 2576381983 / 4*10^6 = 10 min 44 sec

4.
Z88DK April 20, 2020
zsdcc #11566 / new c library / small int math
6388 bytes less page zero

cycle count  = 2609489119
time @ 4MHz  = 2609489119 / 4*10^6 = 10 min 52 sec

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
