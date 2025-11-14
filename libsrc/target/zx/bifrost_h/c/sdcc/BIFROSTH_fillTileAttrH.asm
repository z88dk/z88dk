; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_fillTileAttrH(unsigned char lin,unsigned char col,unsigned char attr)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_fillTileAttrH

EXTERN asm_BIFROSTH_fillTileAttrH

_BIFROSTH_fillTileAttrH:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = lin
	inc hl
	ld e,(hl)       ; E = col
	inc hl
	ld c,(hl)       ; C = attr
	
	jp asm_BIFROSTH_fillTileAttrH
