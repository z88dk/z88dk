; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_readC(void *attrs, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_readC

EXTERN asm_NIRVANAM_readC

_NIRVANAM_readC:

	ld hl,2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)       ; attr
	inc hl
	ld d,(hl)       ; lin
	inc hl
	ld e,(hl)       ; col

   jp asm_NIRVANAM_readC
