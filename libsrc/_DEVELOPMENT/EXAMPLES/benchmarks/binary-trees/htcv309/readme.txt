CHANGES TO SOURCE CODE
======================

All C preprocessor directives like #ifdef, #define, etc must
begin in the first column - there can be no whitespace in front.

The Z88DK pragmas have to be deleted.  Hitech interprets them
even though they are guarded by #ifdef.

VERIFY CORRECT RESULT
=====================

C309 -V -LF -DSTATIC -DPRINTF -O BIN-TREE.C

Run BT.COM and verify correct printout.

TIMING
======

C309 -V -LF -DSTATIC -MBIN-TREE.MAP -O BIN-TREE.C

Program size can be determined from information in the
map file.

TOTAL           Name         Link     Load   Length
                (abs)           0        0        0
                text            0        0     38A1
                data         38A1     38A1      594
                bss          3E35     3E35      24E
                
SIZE = text + data + bss = 0x38A1 + 0x594 + 0x24E = 16515 bytes

To determine timing, the output binary was uploaded and run as a CP/M file.

z88dk-ticks bin-tree.com -counter 999999999

counter = High value to ensure completion

If the result is close to the counter value, the program may have
prematurely terminated so rerun with a higher counter if that is the case.

RESULT
======

HITECH C CPM V309-12
16515 bytes less cpm overhead

cycle count  = 298449848
time @ 4MHz  = 298449848 / 4x10^6 = 74.61 seconds
