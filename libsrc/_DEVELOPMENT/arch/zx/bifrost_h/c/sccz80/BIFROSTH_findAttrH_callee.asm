; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTH_findAttrH(unsigned int lin,unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_findAttrH_callee

BIFROSTH_findAttrH_callee:

        pop hl          ; RET address
        pop bc          ; BC=col
        ex (sp),hl      ; HL=lin

        INCLUDE "arch/zx/bifrost_h/z80/asm_BIFROSTH_findAttrH.asm"
