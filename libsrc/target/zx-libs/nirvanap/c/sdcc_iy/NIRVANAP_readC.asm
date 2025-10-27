; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_readC(void *attrs, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_readC

EXTERN asm_NIRVANAP_readC

_NIRVANAP_readC:

	ld hl,2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)       ; attr
	inc hl
	ld d,(hl)       ; lin
	inc hl
	ld e,(hl)       ; col

   jp asm_NIRVANAP_readC
