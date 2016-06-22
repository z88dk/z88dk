;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: set_pen.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  set_pen
	PUBLIC  _set_pen

set_pen:
_set_pen:
	;__FASTCALL__
	ld	a,l
	jp	kjt_set_pen
