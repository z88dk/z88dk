DHRYSTONE 2.1
=============

https://en.wikipedia.org/wiki/Dhrystone

Original Source Code:
http://www.roylongbottom.org.uk/classic_benchmarks.tar.gz

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and that modified source code is present in
subdirectories.

CPU performance is measured in dhrystones/second which can be
computed from:

DHRYSTONES/S = Number_Of_Runs / Execution_Time

This figure was later reported in terms of performance against
a DEC VAX 11/780.  The VAX had a dhrystone score of 1757 so
this other performance figure called DMIPS is computed as follows:

DMIPS = (DHRYSTONES/S) / 1757

When compiling dhrystone 2.1, several defines are possible:

/*
 * COMMAND LINE DEFINES
 * These replace those discussed above but follow their intentions.
 * 
 * -DREGISTER
 * Corresponds to REG in description above.
 *
 * -DSTATIC
 * Makes REG variables static instead of register.  Overrides REGISTER.
 *
 * -DNOSTRUCTASSIGN
 * Use memcpy instead of struct assignment.
 *
 * -DNOENUM
 * Use defines instead of enumeration.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points (Z88DK).
 *
 * -DTIMEFUNC
 * Platform timer functions are available (must supply timer functions).
 *
 * -DPRINTF
 * Enable text output (Nunber_Of_Runs = 20000 if not enabled).
 *
 */

NOSTRUCTASSIGN and NOENUM can be defined freely depending on whether the
compiler supports struct assignment or enumerations.

All compiles are first checked for correctness by running the program
with PRINTF defined.  After correctness is verified, time should be
measured with PRINTF undefined so that execution time of printf is not
measured.

REGISTER and STATIC can be defined if the compiler's performance can be
improved with these options enabled.

TIMEFUNC allows the host system's own clock to be used for timing so
that results can be printed out as part of the execution.  See source
code for details.

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

For a timed run, the program is compiled and simulated by TICKS.  TICKS
must be given a start address to start timing and a stop address to stop
timing.  In Z88DK compiles these show up in the map file.  Other compilers'
output may have to be disassembled to locate the correct address range.

The output of TICKS is a cycle count.  To convert to time in seconds:

Execution_Time = CYCLE_COUNT / FCPU
where FCPU = clock frequency of Z80 in Hz.

This time can be plugged into the dhrystone formulas above to compute
exact dhrystone performance.

(Number_Of_Runs = 20000 when PRINTF is disabled).


RESULTS
=======

1.
Z88DK March 18, 2017
zsdcc #9852 / classic c library
7265 bytes less page zero

cycle count  = 247720320
time @ 4MHz  = 247720320 / 4x10^6 = 61.9301  seconds
dhrystones/s = 20000 / 61.9301 = 322.9448
DMIPS        = 322.9448 / 1757 = 0.18380

2.
Z88DK March 18, 2017
zsdcc #9852 / new c library
7124 bytes less page zero

cycle count  = 248842927
time @ 4MHz  = 248842927 / 4x10^6 = 62.2107  seconds
dhrystones/s = 20000 / 62.2107 = 321.4879
DMIPS        = 321.4879 / 1757 = 0.18298

3.
HITECH C MSDOS V750
7002 bytes exact

cycle count  = 288200126
time @ 4MHz  = 288200126 / 4x10^6 = 72.0500 seconds
dhrystones/s = 20000 / 72.0500 = 277.5849
DMIPS        = 277.5849 / 1757 = 0.15799

4.
SDCC 3.6.5 #9842 (MINGW64)
7013 bytes less page zero

cycle count  = 292880320
time @ 4MHz  = 292880320 / 4x10^6 = 73.22008  seconds
dhrystones/s = 20000 / 73.2208 = 273.1464
DMIPS        = 273.1464 / 1757 = 0.15546

5.
IAR Z80 V4.06A
7371 bytes less small amount

cycle count  = 306860580
time @ 4MHz  = 306860580 / 4x10^6 = 76.7151  seconds
dhrystones/s = 20000 / 76.7151 = 260.7047
DMIPS        = 260.7047 / 1757 = 0.14838

6.
HITECH C CPM V309
7471 bytes less cpm overhead

cycle count  = 354120220
time @ 4MHz  = 354120220 / 4*10^6 = 88.53 sec
dhrystones/s = 20000 / 88.53 = 225.9120
DMIPS        = 225.9120 / 1757 = 0.12858
