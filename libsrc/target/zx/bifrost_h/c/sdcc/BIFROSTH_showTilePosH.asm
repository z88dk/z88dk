; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_showTilePosH(unsigned char lin,unsigned char col)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_showTilePosH

EXTERN asm_BIFROSTH_showTilePosH

_BIFROSTH_showTilePosH:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = lin
	inc hl
	ld e,(hl)       ; E = col
	
	jp asm_BIFROSTH_showTilePosH
