; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_fillT_raw(unsigned char attr, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_fillT_raw

EXTERN asm_NIRVANAM_fillT

_NIRVANAM_fillT_raw:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; attr
   inc hl
	ld d,(hl)       ; lin
	inc hl
	ld e,(hl)       ; col
   
   jp asm_NIRVANAM_fillT
