; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_fillT(unsigned int attr, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_fillT

EXTERN asm_NIRVANAM_fillT

_NIRVANAM_fillT:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; attr
	inc hl
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col

   	jp asm_NIRVANAM_fillT
