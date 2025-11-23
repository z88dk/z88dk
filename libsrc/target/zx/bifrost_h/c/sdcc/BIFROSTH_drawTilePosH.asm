; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawTilePosH(unsigned char lin,unsigned char col,unsigned char attr)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_drawTilePosH

EXTERN asm_BIFROSTH_drawTilePosH

_BIFROSTH_drawTilePosH:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = lin
	inc hl
	ld e,(hl)       ; E = col
	inc hl
	ld c,(hl)       ; C = attr
	
	jp asm_BIFROSTH_drawTilePosH
