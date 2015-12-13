; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_resetTileImages(void *addr)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_resetTileImages

EXTERN asm_BIFROSTH_resetTileImages

_BIFROSTH_resetTileImages:

        pop af
        pop hl
        push hl
        push af

        jp asm_BIFROSTH_resetTileImages
