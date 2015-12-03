; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_drawW(unsigned int tile, unsigned int lin, unsigned int col)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_drawW

EXTERN asm_NIRVANA_drawW

_NIRVANA_drawW:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; tile
	inc hl
	inc hl
	ld d,(hl)       ; lin
	inc hl
	inc hl
	ld e,(hl)       ; col

   	jp asm_NIRVANA_drawW
