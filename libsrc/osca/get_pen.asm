;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: get_pen.asm,v 1.1 2012-02-29 07:03:53 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_pen

get_pen:
	call	kjt_get_pen
	ld	h,0
	ld	l,a
	ret
