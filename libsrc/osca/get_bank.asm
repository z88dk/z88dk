;
;	Get the OSCA Architecture current bank
;	by Stefano Bodrato, 2011
;
;	int get_bank();
;	Ask which of 15 32KB banks at Z80 address $8000-$FFFF is selected
;
;	$Id: get_bank.asm,v 1.4 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_bank
	
get_bank:
	call kjt_getbank
	ld h,0
	ld l,a
	ret
