; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_fillT(unsigned int attr, unsigned int lin, unsigned int col)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_fillT

EXTERN asm_NIRVANA_fillT

_NIRVANA_fillT:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; attr
	inc hl
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col

   	jp asm_NIRVANA_fillT
