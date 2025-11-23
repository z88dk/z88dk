; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawW(unsigned char tile, unsigned char lin, unsigned char col)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_drawW

EXTERN asm_NIRVANAM_drawW_di

_NIRVANAM_drawW:

	ld hl,2
	add hl,sp
	ld a,(hl)       ; tile
	inc hl
	ld d,(hl)       ; lin
	inc hl
	ld e,(hl)       ; col

	push ix
	
   call asm_NIRVANAM_drawW_di
	
	pop ix
	ret

