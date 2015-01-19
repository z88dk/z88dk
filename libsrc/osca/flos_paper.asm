;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Set paper color
;
;	$Id: flos_paper.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  flos_paper

flos_paper:
	ld	b,h
	ld	c,l
	ld	d,h
	ld	e,l
	jp	kjt_background_colours
