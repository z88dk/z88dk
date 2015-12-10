; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_spriteT(unsigned int sprite, unsigned int tile, unsigned int lin, unsigned int col)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_spriteT

EXTERN asm_NIRVANA_spriteT

_NIRVANA_spriteT:

	ld hl,2
	add hl,sp
	ld c,(hl)       ; sprite
	inc hl
	inc hl
	ld a,(hl)       ; tile
	inc hl
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col
	ld l,c
	ld h,0

   	jp asm_NIRVANA_spriteT
