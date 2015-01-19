;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'remove' but with a FLOS style error handling
;
;	$Id: erase_file.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  erase_file
	EXTERN   flos_err
	
erase_file:
	; __FASTCALL__
	call	kjt_erase_file
	jp   flos_err
