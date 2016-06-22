;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: parent_dir.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

	SECTION code_clib
	PUBLIC  parent_dir
	EXTERN   flos_err

parent_dir:
_parent_dir:
	call	kjt_parent_dir
	jp   flos_err
