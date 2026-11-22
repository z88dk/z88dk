; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_drawTileL(unsigned char row, unsigned char col, unsigned char tile)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_drawTileL

EXTERN asm_BIFROSTL_drawTileL

_BIFROSTL_drawTileL:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = row
	inc hl
	ld e,(hl)       ; E = col
	inc hl
	ld a,(hl)       ; A = tile
	
	jp asm_BIFROSTL_drawTileL
