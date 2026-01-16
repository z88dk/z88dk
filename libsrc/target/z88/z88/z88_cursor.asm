

SECTION code_clib

PUBLIC z88_disable_cursor
PUBLIC _z88_disable_cursor
PUBLIC z88_enable_cursor
PUBLIC _z88_enable_cursor

INCLUDE "stdio.def"


z88_disable_cursor:
_z88_disable_cursor:
    ld      hl,disable_cursor
    call_oz (gn_sop)
    ret

z88_enable_cursor:
_z88_enable_cursor:
    ld      hl,enable_cursor
    call_oz (gn_sop)
    ret




SECTION rodata_clib


enable_cursor:
     defb    1, '2', '+', 'C', 0

disable_cursor:
     defb    1, '2', '-', 'C', 0
