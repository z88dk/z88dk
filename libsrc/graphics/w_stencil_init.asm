;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;	Set/Reset the couple of vectors being part of a "stencil"
;	Basic concept by Rafael de Oliveira Jannone (calculate_side)
;
;       Stefano Bodrato - 13/3/2009
;
;
;	$Id: w_stencil_init.asm,v 1.4 2016-04-23 20:37:40 dom Exp $
;

	INCLUDE	"graphics/grafix.inc"
		SECTION   code_clib
                PUBLIC    stencil_init
                PUBLIC    _stencil_init

.stencil_init
._stencil_init
		; __FASTCALL__ means no need to pick HL ptr from stack
		
		ld	d,h
		ld	e,l
		inc	de
		ld	(hl),127	; big enough but stay in the positive range !
		ld	bc,maxy
		push	bc
		ldir
		pop	bc
		push	bc
		ldir
		pop	bc
		dec	bc
		ld	(hl),0
		push	bc
		ldir
		pop	bc
		ldir
		ret
