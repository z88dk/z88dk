CHANGES TO SOURCE CODE
======================

Replace "#include <stdint.h>" with:

typedef unsigned int  uint16_t;
typedef unsigned long uint32_t;

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas had to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

Replace all instances of "10000UL" with "10000" since HTC does
not understand the suffix.  The compiler should be able to
infer the result size anyway since in all instances the other
operand is 32 bit.

HighTech C CP/M V309 does not have an ldiv() function.

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF PI.C

Run PI.COM and verify correct output.

TIMING
======

CC -V -N -OF -DSTATIC -MPI.MAP PI.C

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0      742
            data          742      742      360
            bss           AA2      AA2     15F4

SIZE = text + data + bss = 0x742 + 0x360 + 0x15F4 = 8342 bytes

z88dk-ticks PI.COM -counter 99999999999 

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
8342 bytes exact

cycle count  = 5532347800
time @ 4MHz  = 5532347800 / 4*10^6 = 23 min 03 sec
