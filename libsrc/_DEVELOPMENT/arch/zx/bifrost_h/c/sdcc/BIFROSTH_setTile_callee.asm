; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_setTile(unsigned int px,unsigned int py,unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_setTile_callee

_BIFROSTH_setTile_callee:

        pop af          ; RET address
        pop hl          ; L=px
        pop bc          ; C=py
        pop de          ; E=tile
        push af

        INCLUDE "arch/zx/bifrost_h/z80/asm_BIFROSTH_setTile.asm"
