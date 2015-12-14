; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_printC(unsigned int ch, unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_printC

EXTERN asm_NIRVANAP_printC

_NIRVANAP_printC:

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

   	jp asm_NIRVANAP_printC
