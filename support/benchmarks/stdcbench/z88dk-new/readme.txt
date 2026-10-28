CHANGES TO SOURCE CODE
======================

None in the upstream modules. The port is portme.h, portme.c, and
zpragma.inc.

zpragma.inc sets CRT_STACK_SIZE to 8192. c90lib calls realloc
(c90lib-htab.c, Safe_realloc). The numbers below use the fast
spare-tail allocator, __CLIB_OPT_MALLOC = 1. The installed newlib is
assembled with that define at 0. Set it in
libsrc/newlib/target/z80/config/config_clib.m4, remove
libsrc/newlib/target/z80/obj/config_private.inc, then
`make -C libsrc/newlib z80` before `make new`. c90base does not call
malloc. Its cycle count does not include heap init. A fast rebuild
can change the c90base file size. It does not change that cycle count.

startup 0 has no stdout. portme.c writes the console on port 1.
ticks uses -iochar 1. The exit halt on these images is at $009E.
-end 9e stops an iotimer run on that halt.

VERIFY CORRECT RESULT
=====================

From support/benchmarks/stdcbench, after the fast-allocator rebuild:

make build/new-sccz80-iotimer/ticks

The image is 29010 bytes. It prints c90base 1, c90lib 2, final 3.
That print truncates the score. The RESULT blocks keep one decimal.
The integer after the scores is the cycle count up to the halt.
The TIMER column is build/new-sccz80-c90base/ticks and
build/new-sccz80-c90lib/ticks.

A run with no ERROR line has passed the self-checks.

TIMING
======

One iteration. TIMER_START and TIMER_STOP bracket that iteration.
From support/benchmarks/stdcbench:

make new

That builds and times sccz80, 80cc stack, 80cc frame, and zsdcc.
Each compiler has a c90base image, a c90lib image, and an iotimer
image. Each result is build/<name>/ticks. make -j is safe. c90lib
and iotimer jobs stop if the map still shows the small allocator.

80cc stack is the default. 80cc frame passes -fframe-pointer.
The 80cc stack c90base iteration is the same 102158431 T-states as
classic. The 80cc frame c90base iteration is the same 102618241
T-states as classic.

On a c90lib map, asm_heap_realloc_unlocked and
asm_heap_realloc_unlocked_fast are the same address.

IN-PROGRAM SCORE
================

`make new` builds the iotimer images. Port 2, buffer _tickbuf,
T-states/40. Pass -x before -end and -mmtimer.

The sccz80 image prints 1, 2, and 3. That print truncates the score.

The 80cc stack image is 29194 bytes. It prints 3, 3, and 6. That
print truncates the score.

The 80cc frame image is 29673 bytes. It prints 3, 3, and 6. That
print truncates the score.

The zsdcc image is 26691 bytes. It prints 1, 1, and 2, and it prints
no ERROR line. Those printed scores are the quotient from __div32.
Newlib places section code_l_xcc, so __div32 is a real address. The
helper is the xcc routine: dividend in DE:HL, divisor at ix+4. The
zsdcc call pushes a 32-bit 100 and the dividend. The reported zsdcc
scores are the TIMER formula: c90base 3.5, c90lib 3.8, total 7.3.

RESULT
======

The byte count is the .bin file size. Page zero is included, the same
definition as the classic results in this benchmark.

Z88DK October 27, 2026
sccz80 / new c library / c90base
7785 bytes less page zero

cycle count  = 168749224
time @ 4MHz  = 168749224 / 4*10^6 = 42.19 sec
stdcbench score = 1.9


Z88DK October 27, 2026
sccz80 / new c library / c90lib
24095 bytes less page zero

cycle count  = 557117716
time @ 4MHz  = 557117716 / 4*10^6 = 139.28 sec
stdcbench score = 2.9

Fast allocator, __CLIB_OPT_MALLOC = 1.


Z88DK October 29, 2026
80cc stack / new c library / c90base
7949 bytes less page zero

cycle count  = 102158431
time @ 4MHz  = 102158431 / 4*10^6 = 25.54 sec
stdcbench score = 3.1


Z88DK October 29, 2026
80cc stack / new c library / c90lib
24130 bytes less page zero

cycle count  = 475987866
time @ 4MHz  = 475987866 / 4*10^6 = 119.00 sec
stdcbench score = 3.4

Fast allocator, __CLIB_OPT_MALLOC = 1.
The both-module iotimer image is 29194 bytes. It printed 3, 3, and 6.
The reported total is 6.5.


Z88DK October 29, 2026
80cc frame / new c library / c90base
8076 bytes less page zero

cycle count  = 102618241
time @ 4MHz  = 102618241 / 4*10^6 = 25.65 sec
stdcbench score = 3.1


Z88DK October 29, 2026
80cc frame / new c library / c90lib
24536 bytes less page zero

cycle count  = 471783902
time @ 4MHz  = 471783902 / 4*10^6 = 117.95 sec
stdcbench score = 3.4

Fast allocator, __CLIB_OPT_MALLOC = 1.
The both-module iotimer image is 29673 bytes. It printed 3, 3, and 6.
The reported total is 6.5.


Z88DK October 27, 2026
zsdcc 4.6.0 #16639 / new c library / c90base
7253 bytes less page zero

cycle count  = 92368035
time @ 4MHz  = 92368035 / 4*10^6 = 23.09 sec
stdcbench score = 3.5

Score is the TIMER formula. The in-program divide by 100 printed 1.


Z88DK October 27, 2026
zsdcc 4.6.0 #16639 / new c library / c90lib
22045 bytes less page zero

cycle count  = 419437901
time @ 4MHz  = 419437901 / 4*10^6 = 104.86 sec
stdcbench score = 3.8

Fast allocator, __CLIB_OPT_MALLOC = 1. Score is the TIMER formula.
The in-program divide by 100 printed 1. The both-module iotimer image
is 26691 bytes, and its printed final score is 2. The reported total
is 7.3.
