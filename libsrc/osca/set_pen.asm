;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: set_pen.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  set_pen

set_pen:
	;__FASTCALL__
	ld	a,l
	jp	kjt_set_pen
