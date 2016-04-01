; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_drawTileH(unsigned int lin,unsigned int col,unsigned int tile)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_drawTileH

EXTERN asm_BIFROST2_drawTileH

BIFROST2_drawTileH:

   	ld hl,2
   	add hl,sp
   	ld a,(hl)       ; A=tile
   	inc hl
   	inc hl
   	ld e,(hl)       ; E=col
   	inc hl
   	inc hl
   	ld d,(hl)       ; D=lin

    jp asm_BIFROST2_drawTileH        ; execute 'draw_tile'
