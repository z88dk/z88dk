STDCBENCH 0.8
=============

https://sourceforge.net/projects/stdcbench/

Philipp K. Krause, "stdcbench - A Benchmark for Small Systems",
SCOPES 2018. The paper is STDC Bench Paper.pdf in this directory.
That paper measured stdcbench 0.4. The sources here are stdcbench 0.8.
The tables below are the 0.8 runs, reported on their own.

The benchmark sources are under GPL-2. See GPL-2 and RULES. The z88dk
ports are z88dk-classic/ and z88dk-new/. Each portme.h and portme.c
has the same role as the upstream SDCC-Z80 and SDCC-R2K examples.

c90base times a freestanding subset of C90. It has no float and no
struct assignment. c90lib times malloc, realloc, qsort, sprintf and
the string functions. Upstream c90float and c90double are stubs and
are left undefined.

One iteration of each module is longer than that module's time budget
at 4 MHz, so the official loop runs once. TIMER_START and TIMER_STOP
bracket that iteration. The score is the formula in c90base.c and
c90lib.c. The program divides in unsigned long and truncates. These
tables round the same quotient to one decimal place. The formula is
unchanged. Some CPU models score above 10. The clock unit is
T-states/40, and STDCBENCH_CLOCKS_PER_SEC is 100000:

  elapsed = cycle_count / 40
  c90base  = (1000 * 800000 / elapsed) / 100
  c90lib   = (1000 * 4000000 / elapsed) / 100
  total    = c90base + c90lib

Bytes is the .bin of the image that holds every module in the total.
When both modules link, that image is the iotimer build. When c90lib
is omitted, it is the c90base build. A dash means that module is
omitted. Page zero is included. Classic and newlib use this same
count. Per-module TIMER sizes for Z80 are in the RESULT blocks.
Those are separate images.

80cc stack is the default. Locals are relative to the stack
pointer. 80cc frame passes -fframe-pointer. Locals are relative to
IX. 8080, 8085, gbz80, and vm1 do not get that flag.

zsdcc is 4.6.0 #16639. Every figure below is from October 30, 2026.
Full Z80 RESULT blocks are in z88dk-classic/readme.txt and
z88dk-new/readme.txt.

From this directory, `make` rebuilds the matrix. `make classic` and
`make new` are the Z80 subsets. `make 8085` is the sccz80 8085
c90base row. `make cpus` is the other CPUs. `make -j` is safe.


CLASSIC Z80
===========

Z80, 4 MHz, classic +test, October 30, 2026.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 27605 |    1.9 |    3.3 |   5.2 |   168_749_272 |  491_595_488
80cc stack | 28110 |    3.1 |    3.9 |   7.0 |   102_158_431 |  410_457_676
80cc frame | 27489 |    3.2 |    4.0 |   7.2 |    99_889_975 |  396_617_692
zsdcc      | 25341 |    3.5 |    4.4 |   7.9 |    91_051_880 |  367_241_838

The sccz80 iotimer image printed 1, 3, and 4. The 80cc stack image
printed 3, 3, and 6. The 80cc frame image printed 3, 4, and 7. The
zsdcc image printed 3, 4, and 7. Those prints truncate this table
to an integer.


CLASSIC Z80N
============

Z80N, classic +test -clib=z80n, ticks -mz80n, October 30, 2026.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 27621 |    2.3 |    3.4 |   5.7 |   140_704_024 |  467_267_723
80cc stack | 28064 |    3.8 |    4.3 |   8.1 |    84_814_256 |  371_155_065
80cc frame | 27423 |    3.9 |    4.5 |   8.4 |    82_545_800 |  355_492_139
zsdcc      | 25272 |    3.9 |    4.6 |   8.5 |    82_038_724 |  344_347_168

Each iotimer image printed these scores as integers. No line starts
with ERROR.


CLASSIC Z180
============

Z180, classic +test -clib=z180, ticks -mz180, October 30, 2026.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 27568 |    2.6 |    4.1 |   6.7 |   120_930_544 |  389_009_433
80cc stack | 28088 |    4.4 |    5.1 |   9.5 |    71_931_776 |  314_934_870
80cc frame | 27358 |    4.7 |    5.4 |  10.1 |    67_688_763 |  297_978_663
zsdcc      | 25464 |    4.9 |    5.6 |  10.5 |    65_429_667 |  287_068_122

Each iotimer image printed these scores as integers. No line starts
with ERROR.


CLASSIC EZ80_Z80
================

eZ80 in Z80 mode, classic +test -clib=ez80_z80, ticks -mez80_z80,
October 30, 2026.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 27373 |    9.4 |   12.3 |  21.7 |    33_943_257 |  130_500_274
80cc stack | 26552 |   16.2 |   15.2 |  31.4 |    19_733_769 |  105_061_481
80cc frame |  8540 |   17.5 |      — |     — |    18_255_523 |             —

80cc frame c90lib printed ERROR. That row is omitted. Bytes on the
frame row is the c90base image. The sccz80 and 80cc stack iotimer
images printed integer scores. No line starts with ERROR on those
two images.


CLASSIC R2KA
============

Rabbit 2000A, classic +test -clib=r2ka, ticks -mr2ka,
October 30, 2026. iotimer Bytes is the linked file size. ticks does
not run these iotimer images.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 25943 |    6.4 |    7.1 |  13.5 |    50_037_876 |  225_245_065
80cc stack | 24384 |    8.3 |    8.4 |  16.7 |    38_392_330 |  191_475_014
80cc frame |  8429 |    8.3 |      — |     — |    38_371_497 |             —

80cc frame c90lib printed ERROR. That row is omitted. Bytes on the
frame row is the c90base image.


CLASSIC R4K
===========

Rabbit 4000, classic +test -clib=rabbit4k, ticks -mr4k,
October 30, 2026. iotimer Bytes is the linked file size. ticks does
not run these iotimer images.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 26726 |    6.1 |    6.8 |  12.9 |    52_216_794 |  234_188_334
80cc stack | 25380 |    8.2 |    7.9 |  16.1 |    39_011_422 |  202_145_577
80cc frame | 24853 |    8.2 |    8.0 |  16.2 |    38_973_749 |  200_899_473


CLASSIC R6K
===========

Rabbit 6000, classic +test -clib=rabbit6k, ticks -mr6k,
October 30, 2026. These rows link the r4k library. iotimer Bytes is
the linked file size. ticks does not run these iotimer images.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 26688 |    6.3 |    6.9 |  13.2 |    50_446_622 |  232_837_336
80cc stack | 25314 |    8.4 |    8.0 |  16.4 |    38_180_518 |  200_647_495
80cc frame | 24799 |    8.3 |    7.9 |  16.2 |    38_539_398 |  201_624_875


CLASSIC KC160
=============

KC160, classic +test -clib=kc160, ticks -mkc160, October 30, 2026.
sccz80 rejected c90lib-lnlc.c. The sccz80 row is c90base only.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     |  8616 |   15.5 |      — |     — |    20_635_028 |             —
80cc stack | 25718 |   21.3 |   20.0 |  41.3 |    14_997_369 |   79_824_069
80cc frame | 24816 |   21.7 |   20.5 |  42.2 |    14_759_558 |   78_081_668

The 80cc iotimer images printed integer scores. No line starts with
ERROR.


CLASSIC R800
============

R800, classic +test -clib=r800, ticks -mr800, October 30, 2026.
80cc rejected c90base-immul.c. There is no 80cc row.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 27544 |    8.4 |   12.5 |  20.9 |    38_184_085 |  128_207_063

The iotimer image printed integer scores. No line starts with ERROR.


CLASSIC 8085
============

8085, classic +test -clib=8085, ticks -m8085, October 30, 2026.
c90base only. This library has no qsort. There is no frame row.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     |  9431 |    2.4 |      — |     — |   130_654_532 |             —
80cc stack |  9143 |    3.4 |      — |     — |    93_980_297 |             —


CLASSIC 8080
============

8080, classic +test -clib=8080, ticks -m8080, October 30, 2026.
c90base only. This library has no qsort. There is no frame row.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     |  9958 |    2.1 |      — |     — |   154_801_872 |             —
80cc stack |  9928 |    3.7 |      — |     — |    86_781_741 |             —


CLASSIC GBZ80
=============

Game Boy CPU, classic +test -clib=gbz80, ticks -mgbz80,
October 30, 2026. c90base only. This library has no qsort.
There is no frame row.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     |  9858 |    2.0 |      — |     — |   159_186_136 |             —
80cc stack |  9496 |    3.2 |      — |     — |   101_352_900 |             —


CLASSIC VM1
===========

KR580VM1, classic +test -clib=vm1, ticks -mvm1, October 30, 2026.
c90base only. This library has no qsort. There is no frame row.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 10446 |    2.1 |      — |     — |   151_770_367 |             —
80cc stack |  9738 |    3.9 |      — |     — |    83_017_750 |             —


NEWLIB Z80
==========

Z80, 4 MHz, +z80 -startup=0, October 30, 2026.

c90lib calls realloc. These rows use the fast spare-tail allocator
(__CLIB_OPT_MALLOC = 1). The shipped newlib define stays 0. Set the
define in libsrc/newlib/target/z80/config/config_clib.m4. Delete
libsrc/newlib/target/z80/obj. Run `make -C libsrc/newlib z80` before
`make new`. c90base does not call malloc. Its cycle count does not
include heap init.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 28733 |    1.9 |    2.9 |   4.8 |   168_749_272 |  557_148_174
80cc stack | 29194 |    3.1 |    3.4 |   6.5 |   102_158_431 |  475_985_786
80cc frame | 28595 |    3.2 |    3.5 |   6.7 |    99_889_975 |  462_149_002
zsdcc      | 26394 |    3.5 |    3.8 |   7.3 |    92_368_235 |  419_469_701

The sccz80 iotimer image printed 1, 2, and 3. The 80cc stack image
printed 3, 3, and 6. The 80cc frame image printed 3, 3, and 6. The
zsdcc image printed 1, 1, and 2. This table uses the TIMER formula
for the zsdcc row. The program divide by 100 calls __div32. That
call produces the printed 1. The workload finishes with no ERROR
line. TIMER_STOP is before that divide.


NEWLIB Z180
===========

Z180, +z180 -startup=0, ticks -mz180, October 30, 2026.
c90lib uses __CLIB_OPT_MALLOC = 1 in
libsrc/newlib/target/z180/config/config_clib.m4. The shipped define
stays 0. Delete libsrc/newlib/target/z180/obj and run
`make -C libsrc/newlib z180` before these rows.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 28778 |    2.6 |    3.6 |   6.2 |   120_930_480 |  446_436_365
80cc stack | 29252 |    4.4 |    4.3 |   8.7 |    71_931_776 |  372_357_318
80cc frame | 28544 |    4.7 |    4.5 |   9.2 |    67_688_763 |  355_428_915
zsdcc      | 26484 |    4.8 |    4.8 |   9.6 |    66_313_393 |  332_911_972

The zsdcc iotimer image printed 4, 4, and 8. That print truncates
each score, then adds the integers. This table keeps one decimal.
No line starts with ERROR.


NEWLIB ZXN
==========

ZX Spectrum Next, +zxn -startup=0 -subtype=bin, ticks -mz80n,
October 30, 2026. c90lib uses __CLIB_OPT_MALLOC = 1 in
libsrc/newlib/target/zxn/config/config_clib.m4. The shipped define
stays 0.

The +zxn default origin is 32768. These rows use origin 0 and
REGISTER_SP 0, from z88dk-new/zxn.inc. That keeps the image under
the stack. Bytes is that file. ticks loads the image at that origin.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 31987 |    2.3 |    3.0 |   5.3 |   140_703_976 |  532_809_233
80cc stack | 32386 |    3.8 |    3.7 |   7.5 |    84_814_256 |  436_702_923
80cc frame | 31767 |    3.9 |    3.8 |   7.7 |    82_545_800 |  421_022_341
zsdcc      | 29620 |    4.0 |    4.0 |   8.0 |    80_025_715 |  396_191_679

The zsdcc iotimer image printed 1, 1, and 2. This table uses the
TIMER formula for that row. The sccz80 image printed 2, 3, and 5.
Each 80cc image printed 3, 3, and 6. No line starts with ERROR.
