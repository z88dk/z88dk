; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getTile(unsigned char px,unsigned char py)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_getTile

EXTERN asm_BIFROSTH_getTile

_BIFROSTH_getTile:

   ld hl,3
	add hl,sp
	ld c,(hl)       ; C = py
	dec hl
	ld l,(hl)       ; L = px
	
	jp asm_BIFROSTH_getTile
