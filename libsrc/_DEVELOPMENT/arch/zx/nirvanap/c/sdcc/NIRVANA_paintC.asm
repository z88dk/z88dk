; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_paintC(unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_paintC

EXTERN asm_NIRVANA_paintC

_NIRVANA_paintC:

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

   	jp asm_NIRVANA_paintC
