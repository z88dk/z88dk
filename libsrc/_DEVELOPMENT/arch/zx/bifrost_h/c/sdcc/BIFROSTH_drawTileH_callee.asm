; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawTileH(unsigned char lin,unsigned char col,unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_drawTileH_callee

EXTERN asm_BIFROSTH_drawTileH

_BIFROSTH_drawTileH_callee:

   pop de
	pop hl
	dec sp
	pop af          ; A = tile
	push de
	ld d,l          ; D = lin
	ld e,h          ; E = col
	
	jp asm_BIFROSTH_drawTileH
