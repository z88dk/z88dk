;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Set paper color
;
;	$Id: flos_paper.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  flos_paper
	PUBLIC  _flos_paper

flos_paper:
_flos_paper:
	ld	b,h
	ld	c,l
	ld	d,h
	ld	e,l
	jp	kjt_background_colours
