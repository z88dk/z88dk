; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_fillTileAttrL(unsigned char row, unsigned char col, unsigned char attr)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_fillTileAttrL

EXTERN asm_BIFROSTL_fillTileAttrL

_BIFROSTL_fillTileAttrL:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = row
	inc hl
	ld e,(hl)       ; E = col
	inc hl
	ld c,(hl)       ; C = attr
	
	jp asm_BIFROSTL_fillTileAttrL
