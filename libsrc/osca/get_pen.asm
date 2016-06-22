;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: get_pen.asm,v 1.4 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_pen
	PUBLIC  _get_pen

get_pen:
_get_pen:
	call	kjt_get_pen
	ld	h,0
	ld	l,a
	ret
