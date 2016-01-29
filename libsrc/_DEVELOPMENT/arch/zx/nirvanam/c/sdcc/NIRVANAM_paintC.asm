; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_paintC(unsigned char *attrs, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_paintC

EXTERN asm_NIRVANAM_paintC

_NIRVANAM_paintC:

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

   	jp asm_NIRVANAM_paintC
