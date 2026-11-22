; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_setTile(unsigned char px,unsigned char py,unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_setTile_callee

EXTERN asm_BIFROST2_setTile

_BIFROST2_setTile_callee:

   pop af
	pop hl     ; L = px
	ld c,h     ; C = py
	dec sp
	pop de
	ld e,d     ; E = tile
	push af
	
	jp asm_BIFROST2_setTile
