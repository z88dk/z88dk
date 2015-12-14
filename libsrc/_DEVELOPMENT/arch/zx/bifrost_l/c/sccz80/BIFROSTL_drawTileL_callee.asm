; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_drawTileL(unsigned int row, unsigned int col, unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC BIFROSTL_drawTileL_callee

EXTERN asm_BIFROSTL_drawTileL

BIFROSTL_drawTileL_callee:

        pop hl          ; RET address
        pop bc          ; C=tile
        pop de          ; E=col
        ex (sp),hl      ; L=row
        ld d,l          ; D=row
        ld a,c          ; A=tile
        
        jp asm_BIFROSTL_drawTileL        ; execute 'draw_tile'
