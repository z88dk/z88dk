; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTL_findAttrH(unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_findAttrH_callee

EXTERN asm_BIFROSTL_findAttrH

BIFROSTL_findAttrH_callee:

        pop hl          ; RET address
        pop bc          ; BC=col
        pop de          ; DE=lin
        push hl

        jp asm_BIFROSTL_findAttrH
