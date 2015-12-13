; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawTilePosH(unsigned int lin,unsigned int col,unsigned int attr)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_drawTilePosH_callee

EXTERN asm_BIFROSTH_drawTilePosH

_BIFROSTH_drawTilePosH_callee:

        pop hl          ; RET address
        pop de          ; E=col
        pop bc          ; C=lin
        ld d,c          ; D=lin
        pop bc          ; C=attrib
        push hl

        jp asm_BIFROSTH_drawTilePosH        ; execute 'draw_tile_pos'
