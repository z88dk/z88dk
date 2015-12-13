; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getTile(unsigned int px,unsigned int py)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_getTile_callee

BIFROSTH_getTile_callee:

        pop hl          ; RET address
        pop bc          ; BC=py
        ex (sp),hl      ; HL=px

        INCLUDE "arch/zx/bifrost_h/z80/asm_BIFROSTH_getTile.asm"
