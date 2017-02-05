; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_setTile(unsigned char px,unsigned char py,unsigned char tile)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_setTile

EXTERN asm_BIFROST2_setTile

_BIFROST2_setTile:

   ld hl,4
	add hl,sp
	ld e,(hl)       ; E = tile
	dec hl
	ld c,(hl)       ; C = py
	dec hl
	ld l,(hl)       ; L = px
	
	jp asm_BIFROST2_setTile
