;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: set_pen.asm,v 1.1 2012-02-29 07:03:53 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  set_pen

set_pen:
	;__FASTCALL__
	ld	a,l
	jp	kjt_set_pen
