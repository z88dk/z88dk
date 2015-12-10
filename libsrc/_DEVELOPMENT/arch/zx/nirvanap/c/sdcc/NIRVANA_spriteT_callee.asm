; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_spriteT(unsigned int sprite, unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_spriteT_callee

EXTERN asm_NIRVANA_spriteT

_NIRVANA_spriteT_callee:

	pop af          ; RET address
	pop hl          ; sprite
	pop bc          ; tile
	pop de          ; lin
	ld d,e
	ld e,c
	pop bc          ; col
	push af
	ld a,e
	ld e,c

	jp asm_NIRVANA_spriteT
