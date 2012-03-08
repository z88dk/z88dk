;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: set_pen.asm,v 1.2 2012-03-08 07:16:46 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  set_pen

set_pen:
	;__FASTCALL__
	ld	a,l
	jp	kjt_set_pen
