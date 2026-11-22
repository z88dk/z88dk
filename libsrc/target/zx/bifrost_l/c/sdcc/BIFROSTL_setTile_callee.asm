; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_setTile(unsigned char px, unsigned char py, unsigned char tile)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_setTile_callee

EXTERN asm_BIFROSTL_setTile

_BIFROSTL_setTile_callee:

   pop af
	pop hl          ; L = px
	ld c,h          ; C = py
	dec sp
	pop de
	ld e,d          ; E = tile
	push af
	
	jp asm_BIFROSTL_setTile
