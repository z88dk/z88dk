; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawW(unsigned int tile, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_drawW

EXTERN asm_NIRVANAM_drawW

_NIRVANAM_drawW:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; tile
	inc hl
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col

   	jp asm_NIRVANAM_drawW
