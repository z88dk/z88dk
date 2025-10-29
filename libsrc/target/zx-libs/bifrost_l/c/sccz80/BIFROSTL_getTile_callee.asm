; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getTile(unsigned int px, unsigned int py)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_getTile_callee

EXTERN asm_BIFROSTL_getTile

BIFROSTL_getTile_callee:

        pop hl          ; RET address
        pop bc          ; BC=py
        ex (sp),hl      ; HL=px

        jp asm_BIFROSTL_getTile
