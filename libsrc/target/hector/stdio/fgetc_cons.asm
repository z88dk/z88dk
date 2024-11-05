; Hector support
;
; Info taken from: https://github.com/tomconte/dontwakecthulhu/blob/main/src/lib.asm

SECTION code_clib

PUBLIC fgetc_cons
PUBLIC _fgetc_cons

INCLUDE "target/hector/def/hector1.def"


fgetc_cons:
_fgetc_cons:
    call    FW_GETC
IF FORhectorhr
    ld      (IO_MODE_HR_VRAM),a
ENDIF
    ld      l,a
    ld      h,0
    ret
