; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_drawTileL(unsigned char row, unsigned char col, unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_drawTileL_callee

EXTERN asm_BIFROSTL_drawTileL

_BIFROSTL_drawTileL_callee:

   pop de
	pop hl
	dec sp
	pop af          ; A = tile
	push de
	ld d,l          ; D = row
	ld e,h          ; E = col
	
	jp asm_BIFROSTL_drawTileL
