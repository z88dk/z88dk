; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_setTile(unsigned char px, unsigned char py, unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_setTile_callee

EXTERN asm_BIFROST2_setTile

BIFROST2_setTile_callee:

        pop hl          ; RET address
        pop de          ; E=tile
        pop bc          ; C=py
        ex (sp),hl      ; L=px

        jp asm_BIFROST2_setTile
