; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROST2_findAttrH(unsigned int lin,unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_findAttrH_callee

_BIFROST2_findAttrH_callee:

        pop de          ; RET address
        pop hl          ; HL=lin
        pop bc          ; BC=col
        push de

        INCLUDE "arch/zx/bifrost2/z80/asm_BIFROST2_findAttrH.asm"
