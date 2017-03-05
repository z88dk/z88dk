CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas had to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

// comments replaced with /**/ comments.

VERIFY CORRECT RESULT
=====================

C -V -O -DSTATIC -DPRINTF SIEVE.C

Run SIEVE.COM and verify correct output.

TIMING
======

C -V -O -DSTATIC -MSIEVE.MAP SIEVE.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0x2c9 + 0x02 + 0x1f4a = 8725 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o sieve0.bin
appmake +inject -b sieve0.bin -i SIEVE.COM -s 256 -o sieve.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks sieve.bin -start 014f -end 01d2 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
8725 bytes less cpm overhead

cycle count  = 4547538
time @ 4MHz  = 4547538 / 4*10^6 = 1.1369 sec
