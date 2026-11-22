; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getTile(unsigned char px,unsigned char py)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_getTile

EXTERN asm_BIFROST2_getTile

_BIFROST2_getTile:

	ld hl,3
	add hl,sp
	ld c,(hl)       ; C = py
	dec hl
	ld l,(hl)       ; L = px

	jp asm_BIFROST2_getTile
