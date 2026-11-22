; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_spriteT(unsigned char sprite, unsigned char tile, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_spriteT

EXTERN asm_NIRVANAP_spriteT

_NIRVANAP_spriteT:

	ld hl,2
	add hl,sp
	ld c,(hl)       ; sprite
	inc hl
	ld a,(hl)       ; tile
	inc hl
	ld d,(hl)       ; lin
	inc hl
	ld e,(hl)       ; col
	ld l,c
	ld h,0

   jp asm_NIRVANAP_spriteT
