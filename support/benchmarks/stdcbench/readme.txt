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
tables round the same quotient to one decimal place. Each score here
is between 1 and 10, so that is two significant digits. The clock
unit is T-states/40, and STDCBENCH_CLOCKS_PER_SEC is 100000:

  elapsed = cycle_count / 40
  c90base  = (1000 * 800000 / elapsed) / 100
  c90lib   = (1000 * 4000000 / elapsed) / 100
  total    = c90base + c90lib

Bytes is the .bin of the image that holds every module in the total.
When both modules link, that image is the iotimer build. When c90lib
is omitted, it is the c90base build. Page zero is included. Classic
and newlib use this same count. Per-module TIMER sizes are in the
RESULT blocks. Those are separate images.

80cc stack is the default. Locals are relative to the stack
pointer. 80cc frame passes -fframe-pointer. Locals are relative to
IX. 8085 does not get that flag.

From this directory, `make` rebuilds the matrix. `make classic`,
`make new`, and `make 8085` are the subsets. `make -j` is safe.

An 8085 sccz80 c90base result is in z88dk-classic/readme.txt. It is
outside these three-compiler tables.


CLASSIC Z80
===========

Z80, 4 MHz, classic +test, October 29, 2026.
Full RESULT blocks: z88dk-classic/readme.txt.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 27605 |    1.9 |    3.3 |   5.2 |   168_749_272 |  491_595_488
80cc stack | 28110 |    3.1 |    3.9 |   7.0 |   102_158_431 |  410_457_676
80cc frame | 28533 |    3.1 |    3.9 |   7.0 |   102_618_241 |  406_156_584
zsdcc      | 25341 |    3.5 |    4.4 |   7.9 |    91_051_880 |  367_241_838

zsdcc is 4.6.0 #16639. The sccz80 iotimer image printed 1, 3, and 4.
The 80cc stack image printed 3, 3, and 6. The 80cc frame image
printed 3, 3, and 6. The zsdcc iotimer image printed 3, 4, and 7.
Those prints are this table truncated to an integer.


NEWLIB Z80
==========

Z80, 4 MHz, +z80 -startup=0, October 29, 2026.
Full RESULT blocks: z88dk-new/readme.txt.

c90lib calls realloc. These rows are the fast spare-tail allocator
(__CLIB_OPT_MALLOC = 1). The installed newlib is built at 0, the
small walker. Set the define in
libsrc/newlib/target/z80/config/config_clib.m4, remove
libsrc/newlib/target/z80/obj/config_private.inc, and run
`make -C libsrc/newlib z80` before `make new`. c90base does not
call malloc. Its cycle count does not include heap init.

Compiler   | Bytes | c90base | c90lib | Total | c90base ticks | c90lib ticks
-----------|------:|-------:|-------:|------:|--------------:|-------------:
sccz80     | 29010 |    1.9 |    2.9 |   4.8 |   168_749_224 |  557_117_716
80cc stack | 29194 |    3.1 |    3.4 |   6.5 |   102_158_431 |  475_987_866
80cc frame | 29673 |    3.1 |    3.4 |   6.5 |   102_618_241 |  471_783_902
zsdcc      | 26691 |    3.5 |    3.8 |   7.3 |    92_368_035 |  419_437_901

zsdcc is 4.6.0 #16639. The sccz80 iotimer image printed 1, 2, and 3.
That print is this sccz80 row truncated to an integer. The 80cc stack
iotimer image printed 3, 3, and 6. The 80cc frame iotimer image
printed 3, 3, and 6. Those prints are this table truncated to an
integer. The zsdcc iotimer image printed 1, 1, and 2.
This table uses the TIMER formula for that row: 3.5 and 3.8, total
7.3. The program's final divide by 100 calls __div32. That call
produces the printed 1. The workload finishes with no ERROR line.
TIMER_STOP is before that divide.
