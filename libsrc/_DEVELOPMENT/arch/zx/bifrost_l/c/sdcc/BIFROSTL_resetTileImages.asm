; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_resetTileImages(void *addr)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_resetTileImages

EXTERN asm_BIFROSTL_resetTileImages

_BIFROSTL_resetTileImages:

        pop af
        pop hl
        push hl
        push af

        jp asm_BIFROSTL_resetTileImages

