; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_h

PUBLIC asm_BIFROSTH_resetAnim2Frames

asm_BIFROSTH_resetAnim2Frames:

        halt
        xor a
        ld (58698),a
        ld hl,128
        ld (58700),hl
        ret
