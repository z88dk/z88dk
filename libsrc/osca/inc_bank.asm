;
;	OSCA Architecture lib
;	by Stefano Bodrato, 2012
;
;	int inc_bank();
;	Move, if possible, to next of 15 32KB banks at Z80 address $8000-$FFFF
;
;	$Id: inc_bank.asm,v 1.5 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  inc_bank
	PUBLIC  _inc_bank
	
inc_bank:
_inc_bank:
	call kjt_incbank
	ld h,0
	ld l,a
	ret z
	ld hl,-1
	ret
