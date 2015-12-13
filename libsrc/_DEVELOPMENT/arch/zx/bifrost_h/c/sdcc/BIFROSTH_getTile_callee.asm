; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getTile(unsigned int px,unsigned int py)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_getTile_callee

_BIFROSTH_getTile_callee:

        pop af          ; RET address
        pop hl          ; HL=px
        pop bc          ; BC=py
        push af

        INCLUDE "arch/zx/bifrost_h/z80/asm_BIFROSTH_getTile.asm"
