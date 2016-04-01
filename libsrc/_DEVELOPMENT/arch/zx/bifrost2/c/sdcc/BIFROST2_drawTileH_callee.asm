; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_drawTileH(unsigned int lin,unsigned int col,unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_drawTileH_callee

EXTERN asm_BIFROST2_drawTileH

_BIFROST2_drawTileH_callee:

        pop hl          ; RET address
        pop bc          ; C=lin
        pop de          ; E=col
        ld d,c          ; D=lin
        ex (sp),hl      ; L=tile
        ld a,l          ; A=tile

        jp asm_BIFROST2_drawTileH        ; execute 'draw_tile'
