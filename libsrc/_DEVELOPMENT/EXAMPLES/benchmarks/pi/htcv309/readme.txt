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

HTC CPM V309 does not have an ldiv() function.

VERIFY CORRECT RESULT
=====================

C -V -O -DSTATIC -DPRINTF PI.C

Run PI.COM and verify correct output.

TIMING
======

C -V -O -DSTATIC -MPI.MAP PI.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0x495 + 0x02 + 0x15f2 = 6793 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o pi0.bin
appmake +inject -b pi0.bin -i PI.COM -s 256 -o pi.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks pi.bin -start 013d -end 0136 -counter 9999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
6793 bytes less cpm overhead

cycle count  = 5531933581
time @ 4MHz  = 5531933581 / 4*10^6 = 23 min 03 sec
