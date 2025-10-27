; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawTileH(unsigned int lin,unsigned int col,unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_drawTileH_callee

EXTERN asm_BIFROSTH_drawTileH

BIFROSTH_drawTileH_callee:

        pop hl          ; RET address
        pop bc          ; C=tile
        pop de          ; E=col
        ex (sp),hl      ; L=lin
        ld d,l          ; D=lin
        ld a,c          ; A=tile
        
        jp asm_BIFROSTH_drawTileH        ; execute 'draw_tile'
