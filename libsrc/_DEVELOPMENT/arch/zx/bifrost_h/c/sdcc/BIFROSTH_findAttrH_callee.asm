; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTH_findAttrH(unsigned int lin,unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_findAttrH_callee

_BIFROSTH_findAttrH_callee:

        pop de          ; RET address
        pop hl          ; HL=lin
        pop bc          ; BC=col
        push de

        INCLUDE "arch/zx/bifrost_h/z80/asm_BIFROSTH_findAttrH.asm"
