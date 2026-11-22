; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_l

PUBLIC asm_BIFROSTL_resetAnim4Frames

asm_BIFROSTL_resetAnim4Frames:

        halt
        ld a,15
        ld (58780),a
        ld hl,64+(256*7)
        ld (58782),hl
        ret
