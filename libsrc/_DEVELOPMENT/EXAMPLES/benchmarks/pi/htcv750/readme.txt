CHANGES TO SOURCE CODE
======================

PI.C

Replace "#include <stdint.h>" with:

typedef unsigned int  uint16_t;
typedef unsigned long uint32_t;

PI_LDIV.C

Replace "#include <stdint.h>" with:

typedef unsigned int  uint16_t;
typedef unsigned long uint32_t;

VERIFY CORRECT RESULT
=====================

PI.C

Using IDE HPDZ.EXE make a new project containing PI.C.
Choose CP/M target and max optimizations with global optimization = 9.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC -DPRINTF.
Build the program, ignoring warnings as they come up.

Run on a cpm emulator to verify results.

PI_LDIV.C

Using IDE HPDZ.EXE make a new project containing PI_LDIV.C.
Choose CP/M target and max optimizations with global optimization = 9.

Under "MAKE->CPP pre-defined symbols" add -DSTATIC -DPRINTF.
Build the program, ignoring warnings as they come up.

Run on a cpm emulator to verify results.

TIMING
======

PI.C

Change options to produce a ROM binary file.
Enable -DSTATIC only for CPP pre-defined symbols.

Rebuild to produce PI.BIN

Program size from the IDE dialog is: 685 (ROM) + 5652 (RAM) = 6337
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks pi.bin -start 00f4 -end 01f7 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

PI_LDIV.C

Change options to produce a ROM binary file.
Enable -DSTATIC only for CPP pre-defined symbols.

Rebuild to produce PI_LDIV.BIN

Program size from the IDE dialog is: 818 (ROM) + 5668 (RAM) = 6486
The two other sections correspond to page zero and initialization code.

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks pi_ldiv.bin -start 00f4 -end 01fe -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.


RESULT
======

PI.C

HITECH C MSDOS V750
6337 bytes exact

cycle count  = 5520768427
time @ 4MHz  = 5520768427 / 4x10^6 = 23 min 00 sec

PI_LDIV.C

HITECH C MSDOS V750
6486 bytes exact

cycle count  = 5884356227
time @ 4MHz  = 5884356227 / 4x10^6 = 24 min 31 sec
