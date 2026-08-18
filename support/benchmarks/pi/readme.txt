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


CLASSIC Z80 / 8085 SUMMARY — PI.C (no ldiv)
===========================================

Timer-bounded classic +test. Full archive: z88dk-classic/readme.txt.

Compiler | CPU  | Ticks
---------|------|----------------
sccz80   | z80  | 4_028_061_102
sccz80   | 8085 | 7_380_146_447  (Jul 2026)
80cc     | z80  | 4_272_344_605  (Aug 18, 2026, -fframe-pointer)
80cc     | 8085 | 7_569_463_213  (Jul 2026)
zsdcc    | z80  | 4_012_863_322  (Aug 16, 2026)


RESULTS - PI.C (NO LDIV)
========================

1.
Z88DK April 4, 2022
sccz80 / new c library / fast int math
9049 bytes less page zero

cycle count  = 1766815709
time @ 4MHz  = 1766815709 / 4*10^6 =  7 min 22 sec

2.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / fast int math
9021 bytes less page zero

cycle count  = 1740634644
time @ 4MHz  = 1740634644 / 4*10^6 =  7 min 15 sec

3.
Z88DK April 4, 2022
sccz80 / new c library / small int math
6340 bytes less page zero

cycle count  = 4028061102
time @ 4MHz  = 4028061102 / 4*10^6 = 16 min 47 sec

4.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / small int math
6298 bytes less page zero

cycle count  = 4010854332
time @ 4MHz  = 4010854332 / 4*10^6 =  16 min 43 sec

5.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library
7175 bytes less page zero

cycle count  = 4012863322
time @ 4MHz  = 4012863322 / 4*10^6 =  16 min 43 sec

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
SDCC 4.6.0 #16608 Linux
6598 bytes less page zero

cycle count  = 7218092827
time @ 4MHz  = 7218092827 / 4*10^6 = 30 min 05 sec

SDCC implements its 32-bit math in C.

10.
IAR Z80 V4.06A
6789 bytes less small amount

cycle count  = 8762223085
time @ 4MHz  = 8762223085 / 4*10^6 = 36 min 31 sec

It looks like IAR implements its 32-bit math in C.

11.
Z88DK July 20, 2026
sccz80 / classic c library / 8085 CPU
7295 bytes less page zero

cycle count  = 7380146447
time @ 4MHz  = 7380146447 / 4*10^6 = 30 min 45 sec

Z88DK August 18, 2026
80cc / classic c library
7633 bytes less page zero

cycle count  = 4272344605
time @ 4MHz  = 4272344605 / 4*10^6 = 17 min 48 sec

Z88DK July 20, 2026
80cc / classic c library / 8085 CPU
7745 bytes less page zero

cycle count  = 7569463213
time @ 4MHz  = 7569463213 / 4*10^6 = 31 min 32 sec

RESULTS - PI_LDIV.C (LDIV USED)
===============================

1.
Z88DK April 4, 2022
sccz80 / new c library / fast int math
9139 bytes less page zero

cycle count  = 1358535133
time @ 4MHz  = 1358535133 / 4*10^6 =  5 min 39 sec

2.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / fast int math
9109 bytes less page zero

cycle count  = 1312921068
time @ 4MHz  = 1312921068 / 4*10^6 =  5 min 28 sec

3.
Z88DK April 4, 2022
sccz80 / new c library / small int math
6428 bytes less page zero

cycle count  = 2578767150
time @ 4MHz  = 2578767150 / 4*10^6 = 10 min 45 sec

4.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / small int math
6395 bytes less page zero

cycle count  = 2563247380
time @ 4MHz  = 2563247380 / 4*10^6 =  10 min 41 sec

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
