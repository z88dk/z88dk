CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas had to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

// comments replaced with /**/ comments.

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF SIEVE.C

Run SIEVE.COM and verify correct output.

TIMING
======

CC -V -N -OF -DSTATIC -MSIEVE.MAP SIEVE.C

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0      58D
            data          58D      58D      360
            bss           8ED      8ED     1F4C

SIZE = text + data + bss = 0x58D + 0x360 + 0x1F4C = 10297 bytes

z88dk-ticks SIEVE.COM -counter 999999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
10297 bytes exact

cycle count  = 7916099
time @ 4MHz  = 7916099 / 4*10^6 = 1.979 sec
