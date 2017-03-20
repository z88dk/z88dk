CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

// style comments have to be replaced with /**/ style.

"const" has to be eliminated from source.

The backslash used to continue the string definition of
"char *alu =" had to be deleted.  It seems things work out ok
without the backslash for line continuation.

VERIFY CORRECT RESULT
=====================

C -V -LF -DSTATIC -DPRINTF -O FASTA.C

Run FASTA.COM and verify correct printout.

TIMING
======

C -V -LF -DSTATIC -O -MFASTA.MAP FASTA.C

Program size can be determined from information in the
map file.

SIZE = text + data + bss = 0xd88 + 0x1df + 0x71 = 4056 bytes

CP/M COM files begin at address 0x100.  To time with TICKS
this needs to be embedded into a binary that starts at
address 0.  Bytes leading up to 0x100 are zeroes, meaning NOP.

appmake +rom -s 32768 -f 0 -o fa0.bin
appmake +inject -b fa0.bin -i FASTA.COM -s 256 -o fa.bin

To determine start and stop timing points, the output binary
was manually inspected.  TICKS command:

ticks fa.bin -start 0420 -end 0494 -counter 999999999

start   = TIMER_START in hex
end     = TIMER_STOP in hex
counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309
4056 bytes less cpm overhead

cycle count  = 188751954
time @ 4MHz  = 188751954 / 4*10^6 = 47.19 sec
