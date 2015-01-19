;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: get_pen.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_pen

get_pen:
	call	kjt_get_pen
	ld	h,0
	ld	l,a
	ret
