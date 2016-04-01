; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getTile(unsigned int px,unsigned int py)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_getTile_callee

BIFROST2_getTile_callee:

        pop hl          ; RET address
        pop bc          ; BC=py
        ex (sp),hl      ; HL=px

        INCLUDE "arch/zx/bifrost2/z80/asm_BIFROST2_getTile.asm"
