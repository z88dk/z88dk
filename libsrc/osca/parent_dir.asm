;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: parent_dir.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  parent_dir
	EXTERN   flos_err

parent_dir:
	call	kjt_parent_dir
	jp   flos_err
