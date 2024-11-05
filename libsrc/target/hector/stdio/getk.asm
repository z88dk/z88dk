; Hector support
;
; Info taken from: https://github.com/tomconte/dontwakecthulhu/blob/main/src/lib.asm

SECTION code_clib

PUBLIC getk
PUBLIC _getk

INCLUDE "target/hector/def/hector1.def"

getk:
_getk:
    call    FW_POLLC
IF FORhectorhr
    ld      (IO_MODE_HR_VRAM),a
ENDIF
    ld      l,a
    ld      h,0
    ret
