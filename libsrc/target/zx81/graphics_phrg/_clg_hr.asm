;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
;
;	$Id: _clg_hr.asm $
;

	MODULE    __pseudohrg_clg_hr

	SECTION   code_graphics
	PUBLIC    _clg_hr
	PUBLIC    __clg_hr

	EXTERN	base_graphics
	EXTERN	_gfxhr_pixtab

	EXTERN	hrg_on

	INCLUDE "graphics/grafix.inc"


._clg_hr
.__clg_hr
;--------------------------------------------------------------------
;
; HRG_Tool_Clear
; hl = pointer to display array
;
; to fill hr_rows lines by 32 characters
; here we use the stack (!) to fill hr_rows x 8 x 16 words with push
;
;--------------------------------------------------------------------

	ld	hl,(base_graphics)

	ld	a,maxy
	ld	c,a
	;push af

	ld	a,(_gfxhr_pixtab)
.floop
	ld b,32
.zloop
	ld (hl),a
	inc hl
	djnz zloop
	
	ld (hl),201
	inc hl
	dec c
	jr nz,floop

	jp hrg_on
