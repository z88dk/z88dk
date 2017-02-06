; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROST_setTile(unsigned char px, unsigned char py, unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_setTile_callee

EXTERN asm_BIFROSTH_setTile

BIFROSTH_setTile_callee:

        pop hl          ; RET address
        pop de          ; E=tile
        pop bc          ; C=py
        ex (sp),hl      ; L=px

		  jp asm_BIFROSTH_setTile
