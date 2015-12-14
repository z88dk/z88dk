; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_l

PUBLIC asm_BIFROSTL_resetTileImages

asm_BIFROSTL_resetTileImages:

        ld (58801),hl
        ret
