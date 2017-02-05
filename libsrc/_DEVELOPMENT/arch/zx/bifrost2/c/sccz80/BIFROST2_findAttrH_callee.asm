; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROST2_findAttrH(unsigned int lin,unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_findAttrH_callee

EXTERN asm_BIFROST2_findAttrH

BIFROST2_findAttrH_callee:

        pop hl          ; RET address
        pop bc          ; BC=col
        ex (sp),hl      ; HL=lin

        jp asm_BIFROST2_findAttrH
