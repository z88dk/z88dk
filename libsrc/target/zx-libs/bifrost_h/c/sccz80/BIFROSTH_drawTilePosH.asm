; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void void BIFROSTH_drawTilePosH(unsigned int lin,unsigned int col,unsigned int attr)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_drawTilePosH

EXTERN asm_BIFROSTH_drawTilePosH

BIFROSTH_drawTilePosH:

        ld hl,2
        add hl,sp
        ld c,(hl)       ; C=attrib
        inc hl
        inc hl
        ld e,(hl)       ; E=col
        inc hl
        inc hl
        ld d,(hl)       ; D=lin

        jp asm_BIFROSTH_drawTilePosH        ; execute 'draw_tile_pos'
