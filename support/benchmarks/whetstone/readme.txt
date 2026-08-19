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
sccz80   | z80  | math32  | 361_935_794     | 11.0517  (Aug 15, 2026)
zsdcc    | z80  | math32  | 369_574_087     | 10.8233  (Aug 16, 2026)
sccz80   | 8085 | math32  | 663_627_145   | 6.0275  (Aug 15, 2026)
sccz80   | z80  | mbf32   | 544_395_320     | 7.3476  (Jul 2026)
sccz80   | 8085 | mbf32   | 548_321_291     | 7.2950  (Jul 2026)
80cc     | z80  | mbf32   | 565_813_830     | 7.0695  (Aug 19, 2026)
80cc     | 8085 | mbf32   | 553_345_612     | 7.2288  (Aug 19, 2026)
sccz80   | z80  | genmath | 1_284_172_870   | 3.1148
80cc     | z80  | math32  | 383_323_980               | 10.4350  (Aug 19, 2026)
80cc     | 8085 | math32  | 656_225_936               | 6.0955  (Aug 19, 2026)


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
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / math48
24 bit mantissa + 8 bit exponent (internally 40+8)
6176 bytes less page zero

cycle count  = 912560516
time @ 4MHz  = 912560516 / 4x10^6 = 228.1401 seconds
KWIPS        = 100*10*1 / 228.1401 = 4.3833
MWIPS        = 4.3833 / 1000 = 0.0043833

4.
Z88DK August 16, 2026
classic/zsdcc 4.6.0 #16639/math48
24 bit mantissa + 8 bit exponent (internally 40+8)
7083 bytes less page zero

cycle count  = 916750272
time @ 4MHz  = 916750272 / 4x10^6 = 229.1876 seconds
KWIPS        = 100*10*1 / 229.1876 = 4.3632
MWIPS        = 4.3632 / 1000 = 0.0043632

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
SDCC 4.6.0 #16608 Linux
24 bit mantissa + 8 bit exponent
10364 bytes less page zero

cycle count  = 1850296726
time @ 4MHz  = 1850296726 / 4x10^6 = 462.5742 seconds
KWIPS        = 100*10*1 / 462.5742 = 2.1618
MWIPS        = 2.1618 / 1000 = 0.0021618

SDCC implements its float library in C.

8.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / new c library / math32
24 bit mantissa + 8 bit exponent
9939 bytes less page zero

cycle count  = 370428446
time @ 4MHz  = 370428446 / 4x10^6 = 92.6071 seconds
KWIPS        = 100*10*1 / 92.6071 = 10.7983
MWIPS        = 10.7983 / 1000 = 0.0107983

9.
Z88DK August 15, 2026
sccz80 / new c library / math32
24 bit mantissa + 8 bit exponent
9151 bytes less page zero

cycle count  = 366266299
time @ 4MHz  = 366266299 / 4x10^6 = 91.5666 seconds
KWIPS        = 100*10*1 / 91.5666 = 10.9210
MWIPS        = 10.9210 / 1000 = 0.0109210

10.
Z88DK August 15, 2026
sccz80 / classic c library / math32
IEEE 32-bit float 24 bit mantissa + 8 bit exponent
9978 bytes less page zero

cycle count  = 361935794
time @ 4MHz  = 361935794 / 4x10^6 = 90.4839 seconds
KWIPS        = 100*10*1 / 90.4839 = 11.0517
MWIPS        = 11.0517 / 1000 = 0.0110517

(After floor/ceil call fix and ldexp negative-pw2 fix; exp path correct.)

10b.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library / math32
IEEE 32-bit float 24 bit mantissa + 8 bit exponent
10732 bytes less page zero

cycle count  = 369574087
time @ 4MHz  = 369574087 / 4x10^6 = 92.3935 seconds
KWIPS        = 100*10*1 / 92.3935 = 10.8233
MWIPS        = 10.8233 / 1000 = 0.0108233

11.
Z88DK August 15, 2026
sccz80 / classic c library / 8085 / math32
IEEE 32-bit float (math32_8085)
11581 bytes less page zero

cycle count  = 663627145
time @ 4MHz  = 663627145 / 4x10^6 = 165.9068 seconds
KWIPS        = 100*10*1 / 165.9068 = 6.0275
MWIPS        = 6.0275 / 1000 = 0.0060275

11b.
Z88DK August 19, 2026
80cc / classic c library / math32
IEEE 32-bit float 24 bit mantissa + 8 bit exponent
14111 bytes less page zero

cycle count  = 383323980
time @ 4MHz  = 383323980 / 4x10^6 = 95.8310 seconds
KWIPS        = 100*10*1 / 95.8310 = 10.4350
MWIPS        = 10.4350 / 1000 = 0.0104350

11c.
Z88DK August 19, 2026
80cc / classic c library / 8085 / math32
IEEE 32-bit float (math32_8085)
13944 bytes less page zero

cycle count  = 656225936
time @ 4MHz  = 656225936 / 4x10^6 = 164.0565 seconds
KWIPS        = 100*10*1 / 164.0565 = 6.0955
MWIPS        = 6.0955 / 1000 = 0.0060955

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
Z88DK August 19, 2026
80cc / classic c library / MBF32
10384 bytes less page zero

cycle count  = 565813830
time @ 4MHz  = 565813830 / 4x10^6 = 141.4535 seconds
KWIPS        = 100*10*1 / 141.4535 = 7.0695
MWIPS        = 7.0695 / 1000 = 0.0070695

Z88DK August 19, 2026
80cc / classic c library / 8085 / MBF32
8372 bytes less page zero

cycle count  = 553345612
time @ 4MHz  = 553345612 / 4x10^6 = 138.3364 seconds
KWIPS        = 100*10*1 / 138.3364 = 7.2288
MWIPS        = 7.2288 / 1000 = 0.0072288

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
