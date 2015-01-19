;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;
;	$Id: create_file.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  create_file
	EXTERN   flos_err

create_file:
	; __FASTCALL__
	call	kjt_create_file
	jp	flos_err
