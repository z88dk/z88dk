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


RESULTS
=======

1.
HITECH C CPM V309
** INCORRECT RESULTS
24 bit mantissa + 8 bit exponent
7605 bytes less cpm overhead

cycle count  = 639413871
time @ 4MHz  = 639413871 / 4*10^6 = 159.8535 sec
KWIPS        = 100*10*1 / 159.8535 = 6.2557
MWIPS        = 6.2557 / 1000 = 0.0062557

2.
Z88DK March 2, 2017
zsdcc #9833 / new c library / math48 float package
24 bit mantissa + 8 bit exponent (internally 40+8)
6153 bytes less page zero

cycle count  = 916537242
time @ 4MHz  = 916537242 / 4x10^6 = 229.1343 seconds
KWIPS        = 100*10*1 / 229.1343 = 4.3643
MWIPS        = 4.3643 / 1000 = 0.0043643

3.
Z88DK March 2, 2017
sccz80 / new c library / math48 float package
40 bit mantissa + 8 bit exponent
5843 bytes less page zero

cycle count  = 970198993
time @ 4MHz  = 970198993 / 4x10^6 = 242.5497  seconds
KWIPS        = 100*10*1 / 242.5497 = 4.1229
MWIPS        = 4.1229 / 1000 = 0.0041229

4.
SDCC 3.6.5 #9842 (MINGW64)
24 bit mantissa + 8 bit exponent
14379 bytes less page zero

cycle count  = 2184812093
time @ 4MHz  = 2184812093 / 4x10^6 = 546.2030  seconds
KWIPS        = 100*10*1 / 546.2030 = 1.8308
MWIPS        = 1.8308 / 1000 = 0.0018308
