; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getTile(unsigned int px, unsigned int py)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_getTile_callee

_BIFROSTL_getTile_callee:

        pop af          ; RET address
        pop hl          ; HL=px
        pop bc          ; BC=py
        push af

        INCLUDE "arch/zx/bifrost_l/z80/asm_BIFROSTL_getTile.asm"
