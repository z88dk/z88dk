; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_fillT(unsigned int attr, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_fillT

EXTERN asm_NIRVANAP_fillT

_NIRVANAP_fillT:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; attr
	inc hl
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col

   	jp asm_NIRVANAP_fillT
