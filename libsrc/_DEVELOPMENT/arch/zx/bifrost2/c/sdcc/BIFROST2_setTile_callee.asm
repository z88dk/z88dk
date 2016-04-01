; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_setTile(unsigned int px,unsigned int py,unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_setTile_callee

_BIFROST2_setTile_callee:

        pop af          ; RET address
        pop hl          ; L=px
        pop bc          ; C=py
        pop de          ; E=tile
        push af

        INCLUDE "arch/zx/bifrost2/z80/asm_BIFROST2_setTile.asm"
