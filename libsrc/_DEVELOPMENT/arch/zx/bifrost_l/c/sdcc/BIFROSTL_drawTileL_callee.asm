; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_drawTileL(unsigned int row, unsigned int col, unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_drawTileL_callee

EXTERN asm_BIFROSTL_drawTileL

_BIFROSTL_drawTileL_callee:

        pop hl          ; RET address
        pop bc          ; C=row
        pop de          ; E=col
        ld d,c          ; D=row
        ex (sp),hl      ; L=tile
        ld a,l          ; A=tile

        jp asm_BIFROSTL_drawTileL        ; execute 'draw_tile'
