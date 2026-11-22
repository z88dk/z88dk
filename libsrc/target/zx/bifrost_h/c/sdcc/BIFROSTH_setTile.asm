; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_setTile(unsigned char px,unsigned char py,unsigned char tile)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_setTile

EXTERN asm_BIFROSTH_setTile

_BIFROSTH_setTile:

   ld hl,4
	add hl,sp
	ld e,(hl)       ; E = tile
	dec hl
	ld c,(hl)       ; C = py
	dec hl
	ld l,(hl)       ; L = px
	
	jp asm_BIFROSTH_setTile
