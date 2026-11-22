CHANGES TO SOURCE CODE
======================

ALL FILES

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

DHRY.H

The Z88DK pragmas had to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

After "include <math.h>" add:

typedef float float_t;
typedef float double_t;

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF -EDHRY.COM DHRY-1.C DHRY-2.C

Renamed source files because CP/M has difficulty with underscores in filenames.

Run DHRY.COM and verify correct printout.

TIMING
======

CC -V -N -OF -DSTATIC -MDHRY.MAP -EDHRY.COM DHRY-1.C DHRY-2.C

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0      AD9
            data          AD9      AD9      3DE
            bss           EB7      EB7     1465
                
SIZE = text + data + bss = 0xAD9 + 0x3DE + 0x1465 = 8988 bytes

To determine timing, the output binary was uploaded and run as a CP/M file.

z88dk-ticks DHRY.COM -counter 999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
8988 bytes exact

cycle count  = 356235065
time @ 4MHz  = 356235065 / 4*10^6 = 89.0588 sec
dhrystones/s = 20000 / 89.0588 = 224.5708
DMIPS        = 224.5708 / 1757 = 0.1278
