; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getTile(unsigned char px, unsigned char py)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_getTile

EXTERN asm_BIFROSTL_getTile

_BIFROSTL_getTile:

   ld hl,3
	add hl,sp
	ld c,(hl)       ; C = py
	dec hl
	ld l,(hl)       ; L = px
	
	jp asm_BIFROSTL_getTile
