;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
;       Invert screen output
;
;
;	$Id: invhrg.asm $
;

	MODULE    __pseudohrg_invhrg

	SECTION   code_graphics
	PUBLIC	invhrg
	PUBLIC	_invhrg

	EXTERN	base_graphics

	INCLUDE "graphics/grafix.inc"


invhrg:
_invhrg:
	ld	hl,(base_graphics)

	ld	a,maxy
	ld	c,a
	;push af

.floop
	ld b,32
.zloop
	ld a,(hl)
	xor 128
	ld (hl),a
	inc hl
	djnz zloop
	
;	ld (hl),201
	inc hl
	dec c
	jr nz,floop
	ret

