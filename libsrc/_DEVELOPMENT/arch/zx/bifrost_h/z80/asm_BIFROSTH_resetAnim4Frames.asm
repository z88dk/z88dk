; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_h

PUBLIC asm_BIFROSTH_resetAnim4Frames

asm_BIFROSTH_resetAnim4Frames:

        halt
        ld a,15
        ld (58698),a
        ld hl,64+(256*7)
        ld (58700),hl
        ret
