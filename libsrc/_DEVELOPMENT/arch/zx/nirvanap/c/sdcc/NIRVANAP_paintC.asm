; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_paintC(unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_paintC

EXTERN asm_NIRVANAP_paintC

_NIRVANAP_paintC:

	ld hl,2
	add hl,sp
	ld c,(hl)
	inc hl
	ld b,(hl)       ; attr
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col

   	jp asm_NIRVANAP_paintC
