CHANGES TO SOURCE CODE
======================

None in the upstream modules. The port is portme.h and portme.c.

VERIFY CORRECT RESULT
=====================

From support/benchmarks/stdcbench:

zcc +test -vn -O2 -D__Z88DK -DSTDCBENCH_WHICH=3 \
  -I. -Iz88dk-classic *.c z88dk-classic/portme.c \
  -o stdcbench.bin -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1

z88dk-ticks stdcbench.bin -counter 999999999999

The printed scores are 0. That is not a result: this clock ends the
loop after one iteration. The run passed when no line starts with ERROR.

8085 builds c90base only. Add -clib=8085 to zcc and -m8085 before the
binary.

TIMING
======

One iteration. TIMER_START and TIMER_STOP bracket that iteration.
From support/benchmarks/stdcbench:

make classic

That builds and times sccz80, 80cc, and zsdcc, each for c90base and
c90lib, and it builds the three iotimer images. Each result is
build/<name>/ticks. make -j is safe. 80cc is built without
-fframe-pointer.

make 8085

is sccz80 c90base with -clib=8085 and z88dk-ticks -m8085.

IN-PROGRAM SCORE
================

`make classic` also builds the iotimer images. Port 2, buffer
_tickbuf, T-states/40. The sccz80 image printed 1, 3, and 4.
The 80cc image printed 3, 3, and 6. That image is 28110 bytes.
The zsdcc image printed 3, 4, and 7. That image is 25341 bytes.
Those prints truncate the score. The RESULT blocks keep one decimal.

RESULT
======

Z88DK October 27, 2026
sccz80 / classic c library / c90base
9118 bytes less page zero

cycle count  = 168749272
time @ 4MHz  = 168749272 / 4*10^6 = 42.19 sec
stdcbench score = 1.9


Z88DK October 27, 2026
sccz80 / classic c library / c90lib
22630 bytes less page zero

cycle count  = 491595488
time @ 4MHz  = 491595488 / 4*10^6 = 122.90 sec
stdcbench score = 3.3


Z88DK October 27, 2026
sccz80 / classic c library / 8085 / c90base
9431 bytes less page zero

cycle count  = 130654532
time @ 4MHz  = 130654532 / 4*10^6 = 32.66 sec
stdcbench score = 2.4


Z88DK October 27, 2026
80cc / classic c library / c90base
9035 bytes less page zero

cycle count  = 102158431
time @ 4MHz  = 102158431 / 4*10^6 = 25.54 sec
stdcbench score = 3.1


Z88DK October 27, 2026
80cc / classic c library / c90lib
22988 bytes less page zero

cycle count  = 410457676
time @ 4MHz  = 410457676 / 4*10^6 = 102.61 sec
stdcbench score = 3.9


Z88DK October 27, 2026
zsdcc 4.6.0 #16639 / classic c library / c90base
8627 bytes less page zero

cycle count  = 91051880
time @ 4MHz  = 91051880 / 4*10^6 = 22.76 sec
stdcbench score = 3.5


Z88DK October 27, 2026
zsdcc 4.6.0 #16639 / classic c library / c90lib
20657 bytes less page zero

cycle count  = 367241838
time @ 4MHz  = 367241838 / 4*10^6 = 91.81 sec
stdcbench score = 4.4
