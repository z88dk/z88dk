;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Create directory
;
;	$Id: make_dir.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  make_dir
	EXTERN   flos_err
	
make_dir:
	call	kjt_make_dir
	jp      flos_err
