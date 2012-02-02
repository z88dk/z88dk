;
;	OSCA Architecture lib
;	by Stefano Bodrato, 2012
;
;	int inc_bank();
;	Move, if possible, to next of 15 32KB banks at Z80 address $8000-$FFFF
;
;	$Id: inc_bank.asm,v 1.1 2012-02-02 16:12:58 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  inc_bank
	
inc_bank:
	call kjt_incbank
	ld h,0
	ld l,a
	ret z
	ld hl,-1
	ret
