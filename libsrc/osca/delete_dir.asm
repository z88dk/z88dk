;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;
;	$Id: delete_dir.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  delete_dir
	EXTERN   flos_err
	
delete_dir:
	; __FASTCALL__
	call	kjt_delete_dir
	jp   flos_err
