;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: root_dir.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  root_dir
	EXTERN   flos_err
	
root_dir:
	call	kjt_root_dir
	jp   flos_err
