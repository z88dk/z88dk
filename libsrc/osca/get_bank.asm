;
;	Get the OSCA Architecture current bank
;	by Stefano Bodrato, 2011
;
;	int get_bank();
;	Ask which of 15 32KB banks at Z80 address $8000-$FFFF is selected
;
;	$Id: get_bank.asm,v 1.5 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_bank
	PUBLIC  _get_bank
	
get_bank:
_get_bank:
	call kjt_getbank
	ld h,0
	ld l,a
	ret
