; Hector support
;
; Info taken from: https://github.com/tomconte/dontwakecthulhu/blob/main/src/lib.asm

SECTION code_clib

PUBLIC getk
PUBLIC _getk


getk:
_getk:
    call    0x07e7
    ld      l,a
    ld      h,0
    ret
