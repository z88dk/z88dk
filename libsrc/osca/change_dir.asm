;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Enter in current directory entry
;
;	$Id: change_dir.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  change_dir
	EXTERN   flos_err
	
change_dir:
	call	kjt_change_dir
	jp      flos_err
