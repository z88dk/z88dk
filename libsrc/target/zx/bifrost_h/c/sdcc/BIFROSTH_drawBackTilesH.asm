; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawBackTilesH(unsigned char lin,unsigned char col,unsigned char attr)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_drawBackTilesH

EXTERN asm_BIFROSTH_drawBackTilesH

_BIFROSTH_drawBackTilesH:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = lin
	inc hl
	ld e,(hl)       ; E = col
	inc hl
	ld c,(hl)       ; C = attr
	
	jp asm_BIFROSTH_drawBackTilesH
