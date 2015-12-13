; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawTileH(unsigned int lin,unsigned int col,unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_drawTileH_callee

EXTERN asm_BIFROSTH_drawTileH

_BIFROSTH_drawTileH_callee:

        pop hl          ; RET address
        pop bc          ; C=lin
        pop de          ; E=col
        ld d,c          ; D=lin
        ex (sp),hl      ; L=tile
        ld a,l          ; A=tile

        jp asm_BIFROSTH_drawTileH        ; execute 'draw_tile'
