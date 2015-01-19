;
;	OSCA Architecture lib
;	by Stefano Bodrato, 2012
;
;	int inc_bank();
;	Move, if possible, to next of 15 32KB banks at Z80 address $8000-$FFFF
;
;	$Id: inc_bank.asm,v 1.4 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  inc_bank
	
inc_bank:
	call kjt_incbank
	ld h,0
	ld l,a
	ret z
	ld hl,-1
	ret
