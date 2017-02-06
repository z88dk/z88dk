; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; void BIFROSTL_showTilePosL(unsigned char row, unsigned char col)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_showTilePosL

EXTERN asm_BIFROSTL_showTilePosL

_BIFROSTL_showTilePosL:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = row
	inc hl
	ld e,(hl)       ; E = col
	
	jp asm_BIFROSTL_showTilePosL
