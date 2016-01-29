; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_printC(unsigned int ch, unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_printC

EXTERN asm_NIRVANAM_printC

_NIRVANAM_printC:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; ch
	inc hl
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)       ; attrs
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col

   	jp asm_NIRVANAM_printC
