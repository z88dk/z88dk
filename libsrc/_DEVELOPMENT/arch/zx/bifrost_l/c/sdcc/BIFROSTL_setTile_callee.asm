; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_setTile(unsigned int px, unsigned int py, unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_setTile_callee

_BIFROSTL_setTile_callee:

        pop af          ; RET address
        pop hl          ; L=px
        pop bc          ; C=py
        pop de          ; E=tile
        push af

        INCLUDE "arch/zx/bifrost_l/z80/asm_BIFROSTL_setTile.asm"
