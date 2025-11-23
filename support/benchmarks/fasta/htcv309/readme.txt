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

Compiled with C309-15 from https://github.com/agn453/HI-TECH-Z80-C

VERIFY CORRECT RESULT
=====================

CC -V -N -OF -DSTATIC -DPRINTF FASTA.C -LF

Run FASTA.COM and verify correct printout.

TIMING
======

CC -V -N -OF -DSTATIC -MFASTA.MAP FASTA.C -LF

Program size can be determined from information in the
map file.

TOTAL       Name         Link     Load   Length
            (abs)           0        0        0
            text            0        0     1056
            data         1056     1056      53D
            bss          1593     1593       73
                
SIZE = text + data + bss = 0x1056 + 0x53D + 0x73 = 5638 bytes

To determine timing, the output binary was uploaded and run as a CP/M file.

z88dk-ticks FASTA.COM -counter 999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-15
5638 bytes exact

cycle count  = 189901647
time @ 4MHz  = 189901647 / 4*10^6 = 47.4754 sec
