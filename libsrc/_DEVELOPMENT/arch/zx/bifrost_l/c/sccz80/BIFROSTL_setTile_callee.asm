; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_setTile(unsigned int px, unsigned int py, unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_setTile_callee

EXTERN asm_BIFROSTL_setTile

BIFROSTL_setTile_callee:

        pop hl          ; RET address
        pop de          ; E=tile
        pop bc          ; C=py
        ex (sp),hl      ; L=px

        jp asm_BIFROSTL_setTile
