
;
; Invoke a GSX/GIOS function with 2 coordinates (4 values) in "ptsin"
;

;
; $Id: gios_2px.asm $
;

SECTION code_clib

PUBLIC	gios_2px
PUBLIC	_gios_2px

EXTERN asm_gios_2px

EXTERN	gios_ptsin

gios_2px:
_gios_2px:

	ld	hl,2
	add	hl,sp
	ld	de,gios_ptsin+7
	ld	b,4
cploop:
	ld	a,(hl)
	inc	hl
	ld	c,a
	ld	a,(hl)
	inc	hl
	ld	(de),a
	dec de
	ld	a,c
	ld	(de),a
	dec de
	dec	b
	jr	nz,cploop
	ld	a,(hl)		; fn
	ld	e,a
	ld	d,0
   
	jp asm_gios_2px
