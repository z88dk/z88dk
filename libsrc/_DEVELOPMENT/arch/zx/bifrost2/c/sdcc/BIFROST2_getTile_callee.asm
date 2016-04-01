; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getTile(unsigned int px,unsigned int py)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_getTile_callee

_BIFROST2_getTile_callee:

        pop af          ; RET address
        pop hl          ; HL=px
        pop bc          ; BC=py
        push af

        INCLUDE "arch/zx/bifrost2/z80/asm_BIFROST2_getTile.asm"
