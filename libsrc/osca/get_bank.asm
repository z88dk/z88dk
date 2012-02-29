;
;	Get the OSCA Architecture current bank
;	by Stefano Bodrato, 2011
;
;	int get_bank();
;	Ask which of 15 32KB banks at Z80 address $8000-$FFFF is selected
;
;	$Id: get_bank.asm,v 1.2 2012-02-29 07:03:53 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_bank
	
get_bank:
	call kjt_getbank
	ld h,0
	ld l,a
	ret
