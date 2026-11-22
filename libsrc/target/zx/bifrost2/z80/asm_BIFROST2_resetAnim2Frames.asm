; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost2

PUBLIC asm_BIFROST2_resetAnim2Frames

asm_BIFROST2_resetAnim2Frames:

        halt
        xor a
        ld (51708),a
        ld hl,128
        ld (51710),hl
        ret
