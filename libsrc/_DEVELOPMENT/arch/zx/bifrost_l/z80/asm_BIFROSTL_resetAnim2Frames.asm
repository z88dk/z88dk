; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_l

PUBLIC asm_BIFROSTL_resetAnim2Frames

asm_BIFROSTL_resetAnim2Frames:

        halt
        xor a
        ld (58780),a
        ld hl,128
        ld (58782),hl
        ret
