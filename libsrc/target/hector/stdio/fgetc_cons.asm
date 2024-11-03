; Hector support
;
; Info taken from: https://github.com/tomconte/dontwakecthulhu/blob/main/src/lib.asm

SECTION code_clib

PUBLIC fgetc_cons
PUBLIC _fgetc_cons


fgetc_cons:
_fgetc_cons:
    call    0x07e0
    ld      l,a
    ld      h,0
    ret
