WHETSTONE 1.2
=============

https://en.wikipedia.org/wiki/Whetstone_(benchmark)
http://www.electronic-engineering.ch/fpga/projects/whetstone/Whetstone.pdf
http://www.roylongbottom.org.uk/whetstone.htm

Original Source Code:
http://www.netlib.org/benchmark/whetstone.c

Check Out How the Z80 Compares to Historical Results:
http://www.roylongbottom.org.uk/whetstone.htm#anchorIndex

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and any modified source code is present in
subdirectories.

Floating point performance is measured in KWIPS (kilo-whetstones
per second) or MWIPS (millions of whetstone per second) which
can be computed from:

KWIPS = 100*LOOPS*ITERATIONS / Execution_Time
MWIPS = KWIPS / 1000

In these timing tests, LOOPS will default to 10 and ITERATIONS
will default to 1.

As can be expected, the implementation's floating point precision
will greatly impact on comparative accuracy and performance so
the floating point format must be reported along with KWIPS rating
to allow for suitable insight into results.

When compiling whetstone 1.2, several defines are possible:

/*
 * COMMAND LINE DEFINES
 *
 * -DSTATIC
 * Use static variables instead of locals.
 *
 * -DPRINTOUT
 * Enable printing of intermediate results.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points (Z88DK).
 *
 * -DTIMEFUNC
 * Platform timer functions are available (must supply timer functions).
 *
 * -DCOMMAND
 * Enable command line processing (LOOP=10, II=1 if disabled).
 *
 */

STATIC can be defined freely for best compiler performance.

All compiles are first checked for correctness by running the program
with PRINTOUT defined.  After correctness is verified, time should be
measured with PRINTOUT undefined so that execution time of printf is not
measured.

=====================================

RESULTS ARE ALLOWED TO VARY SOMEWHAT
DUE TO DIFFERENCES IN FLOAT PRECISION

N=      0 J=      0 K=      0
X1=  1.0000e+00 X2= -1.0000e+00
X3= -1.0000e+00 X4= -1.0000e+00

N=    120 J=    140 K=    120
X1= -6.8342e-02 X2= -4.6264e-01
X3= -7.2972e-01 X4= -1.1240e+00

N=    140 J=    120 K=    120
X1= -5.5336e-02 X2= -4.4744e-01
X3= -7.1097e-01 X4= -1.1031e+00

N=   3450 J=      1 K=      1
X1=  1.0000e+00 X2= -1.0000e+00
X3= -1.0000e+00 X4= -1.0000e+00

N=   2100 J=      1 K=      2
X1=  6.0000e+00 X2=  6.0000e+00
X3= -7.1097e-01 X4= -1.1031e+00

N=    320 J=      1 K=      2
X1=  4.9041e-01 X2=  4.9041e-01
X3=  4.9039e-01 X4=  4.9039e-01

N=   8990 J=      1 K=      2
X1=  1.0000e+00 X2=  1.0000e+00
X3=  9.9994e-01 X4=  9.9994e-01

N=   6160 J=      1 K=      2
X1=  3.0000e+00 X2=  2.0000e+00
X3=  3.0000e+00 X4= -1.1031e+00

N=      0 J=      2 K=      3
X1=  1.0000e+00 X2= -1.0000e+00
X3= -1.0000e+00 X4= -1.0000e+00

N=    930 J=      2 K=      3
X1=  8.3467e-01 X2=  8.3467e-01
X3=  8.3467e-01 X4=  8.3467e-01

=====================================

TIMEFUNC allows the host system's own clock to be used for timing so
that results can be printed out as part of the execution.  See source
code for details.

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

When COMMAND is not defined, LOOP=10 and II=1.

For a timed run, the program is compiled and simulated by TICKS.  TICKS
must be given a start address to start timing and a stop address to stop
timing.  In Z88DK compiles these show up in the map file.  Other compilers'
output may have to be disassembled to locate the correct address range.

The output of TICKS is a cycle count.  To convert to time in seconds:

Execution_Time = CYCLE_COUNT / FCPU
where FCPU = clock frequency of Z80 in Hz.

This time can be plugged into the whetstone formulas above to compute
exact KWIPS performance.


CLASSIC Z80 / 8085 SUMMARY
==========================

Timer-bounded classic +test (main z80/8085). Full RESULT blocks:
z88dk-classic/readme.txt.

Compiler | CPU  | Library | Ticks           | KWIPS @ 4 MHz
---------|------|---------|-----------------|----------------
sccz80   | z80  | math32  | 362_151_861     | 11.0451  (Aug 10, 2026)
zsdcc    | z80  | math32  | 369_951_886     | 10.8122  (Aug 10, 2026)
sccz80   | 8085 | math32  | 663_596_725   | 6.0278  (Aug 15, 2026)
sccz80   | z80  | mbf32   | 544_395_320     | 7.3476  (Jul 2026)
sccz80   | 8085 | mbf32   | 548_321_291     | 7.2950  (Jul 2026)
80cc     | z80  | mbf32   | 558_782_473     | 7.1584  (Jul 2026)
80cc     | 8085 | mbf32   | 561_486_320     | 7.1240  (Jul 2026)
sccz80   | z80  | genmath | 1_284_172_870   | 3.1148
80cc     | *    | math32  | SKIP — does not reach TIMER_STOP


RESULTS (full multi-toolchain archive)
======================================

1.
HITECH C CPM V309-15
** INCORRECT RESULTS
24 bit mantissa + 8 bit exponent
9076 bytes exact

cycle count  = 646520995
time @ 4MHz  = 646520995 / 4*10^6 = 161.6302 sec
KWIPS        = 100*10*1 / 161.6302 = 6.187
MWIPS        = 6.187 / 1000 = 0.006187

2.
IAR Z80 V4.06A
24 bit mantissa + 8 bit exponent
6524 bytes less small amount

cycle count  = 732360277
time @ 4MHz  = 732360277 / 4*10^6 = 183.0901 seconds
KWIPS        = 100*10*1 / 183.0901 = 5.4618
MWIPS        = 5.4618 / 1000 = 0.0054618

3.
Z88DK April 28, 2021
zsdcc #12070 / new c library / math48
24 bit mantissa + 8 bit exponent (internally 40+8)
6221 bytes less page zero

cycle count  = 914412771
time @ 4MHz  = 914412771 / 4x10^6 = 228.6031 seconds
KWIPS        = 100*10*1 / 228.6031 = 4.3743
MWIPS        = 4.3743 / 1000 = 0.0043743

4.
Z88DK January 3, 2022
classic/zsdcc #12070/math48
24 bit mantissa + 8 bit exponent (internally 40+8)
7064 bytes less page zero

cycle count  = 917739704
time @ 4MHz  = 917739704 / 4x10^6 = 229.4349 seconds
KWIPS        = 100*10*1 / 230.1954 = 4.3585
MWIPS        = 4.3585 / 1000 = 0.0043585

5.
Z88DK April 28, 2021
sccz80 / new c library / math48 float package
40 bit mantissa + 8 bit exponent
5362 bytes less page zero

cycle count  = 972899568
time @ 4MHz  = 972899568 / 4x10^6 = 243.2248 seconds
KWIPS        = 100*10*1 / 243.2248 = 4.1114
MWIPS        = 4.1114 / 1000 = 0.0041114

6.
Z88DK January 3, 2022
sccz80 / classic c library / genmath float package
40 bit mantissa + 8 bit exponent
6411 bytes less page zero

cycle count  = 1284172870
time @ 4MHz  = 1284172870 / 4x10^6 = 321.0432 seconds
KWIPS        = 100*10*1 / 320.8179 = 3.1148
MWIPS        = 3.1148 / 1000 = 0.0031148

7.
SDCC 4.2.0 Linux
24 bit mantissa + 8 bit exponent
10935 bytes less page zero

cycle count  = 1491668242
time @ 4MHz  = 1491668242 / 4x10^6 = 372.9170 seconds
KWIPS        = 100*10*1 / 372.9170 = 2.6816
MWIPS        = 2.6816 / 1000 = 0.0026816

SDCC implements its float library in C.

8.
Z88DK August 10, 2026
zsdcc #15242 / new c library / math32
24 bit mantissa + 8 bit exponent
9963 bytes less page zero

cycle count  = 520667516
time @ 4MHz  = 520667516 / 4x10^6 = 130.1669 seconds
KWIPS        = 100*10*1 / 130.1669 = 7.6824
MWIPS        = 7.6824 / 1000 = 0.0076824

9.
Z88DK August 10, 2026
sccz80 / new c library / math32
24 bit mantissa + 8 bit exponent
8980 bytes less page zero

cycle count  = 362118261
time @ 4MHz  = 362118261 / 4x10^6 = 90.5296 seconds
KWIPS        = 100*10*1 / 90.5296 = 11.0461
MWIPS        = 11.0461 / 1000 = 0.0110461

10.
Z88DK August 10, 2026
sccz80 / classic c library / math32
IEEE 32-bit float 24 bit mantissa + 8 bit exponent
9811 bytes less page zero

cycle count  = 362151861
time @ 4MHz  = 362151861 / 4x10^6 = 90.5380 seconds
KWIPS        = 100*10*1 / 90.5380 = 11.0451
MWIPS        = 11.0451 / 1000 = 0.0110451

(After floor/ceil call fix and ldexp negative-pw2 fix; exp path correct.)

10b.
Z88DK August 10, 2026
zsdcc / classic c library / math32
IEEE 32-bit float 24 bit mantissa + 8 bit exponent
10592 bytes less page zero

cycle count  = 369951886
time @ 4MHz  = 369951886 / 4x10^6 = 92.4880 seconds
KWIPS        = 100*10*1 / 92.4880 = 10.8122
MWIPS        = 10.8122 / 1000 = 0.0108122

11.
Z88DK August 15, 2026
sccz80 / classic c library / 8085 / math32
IEEE 32-bit float (math32_8085)
11641 bytes less page zero

cycle count  = 663596725
time @ 4MHz  = 663596725 / 4x10^6 = 165.8992 seconds
KWIPS        = 100*10*1 / 165.8992 = 6.0278
MWIPS        = 6.0278 / 1000 = 0.0060278

12.
Z88DK July 19, 2026
sccz80 / classic c library / MBF32
Microsoft 32-bit math 24 bit mantissa + 8 bit exponent
6206 bytes less page zero

cycle count  = 544395320
time @ 4MHz  = 544395320 / 4x10^6 = 136.0988 seconds
KWIPS        = 100*10*1 / 136.0988 = 7.3476
MWIPS        = 7.3476 / 1000 = 0.0073476

13.
Z88DK July 20, 2026
80cc / classic c library / MBF32
10122 bytes less page zero

cycle count  = 558782473
time @ 4MHz  = 558782473 / 4x10^6 = 139.6956 seconds
KWIPS        = 100*10*1 / 139.6956 = 7.1584
MWIPS        = 7.1584 / 1000 = 0.0071584

Z88DK July 20, 2026
80cc / classic c library / 8085 / MBF32
9670 bytes less page zero

cycle count  = 561486320
time @ 4MHz  = 561486320 / 4x10^6 = 140.3716 seconds
KWIPS        = 100*10*1 / 140.3716 = 7.1240
MWIPS        = 7.1240 / 1000 = 0.0071240

Z88DK July 19, 2026
sccz80 / classic c library / 8085 CPU / MBF32
Microsoft 32-bit math 24 bit mantissa + 8 bit exponent
5959 bytes less page zero

cycle count  = 548321291
time @ 4MHz  = 548321291 / 4x10^6 = 137.0803 seconds
KWIPS        = 100*10*1 / 137.0803 = 7.2950
MWIPS        = 7.2950 / 1000 = 0.0072950

14.
HITECH C MSDOS V780pl2
24 bit mantissa + 8 bit exponent
6919 bytes exact

cycle count  = 614748605
time @ 4MHz  = 614748605 / 4x10^6 = 153.6871 seconds
KWIPS        = 100*10*1 / 153.6871 = 6.5067
MWIPS        = 6.5067 / 1000 = 0.0065067
