; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_fillTileAttrL(unsigned char row, unsigned char col, unsigned char attr)
; callee

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_fillTileAttrL_callee

EXTERN asm_BIFROSTL_fillTileAttrL

_BIFROSTL_fillTileAttrL_callee:

   pop de
	pop hl
	dec sp
	pop bc
	push de
	ld c,b          ; C = attr
	ld d,l          ; D = row
	ld e,h          ; E = col
	
	jp asm_BIFROSTL_fillTileAttrL
