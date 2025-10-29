; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost2

PUBLIC asm_BIFROST2_resetAnim4Frames

asm_BIFROST2_resetAnim4Frames:

        halt
        ld a,15
        ld (51708),a
        ld hl,64+(256*7)
        ld (51710),hl
        ret
