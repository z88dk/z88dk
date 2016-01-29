; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_spriteT(unsigned int sprite, unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_spriteT_callee

EXTERN asm_NIRVANAM_spriteT

_NIRVANAM_spriteT_callee:

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

	jp asm_NIRVANAM_spriteT
