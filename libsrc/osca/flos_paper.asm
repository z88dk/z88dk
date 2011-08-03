;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Set paper color
;
;	$Id: flos_paper.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  flos_paper

flos_paper:
	ld	b,h
	ld	c,l
	ld	d,h
	ld	e,l
	jp	kjt_background_colours
