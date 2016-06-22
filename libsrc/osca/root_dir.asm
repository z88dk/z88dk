;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: root_dir.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  root_dir
	PUBLIC  _root_dir
	EXTERN   flos_err
	
root_dir:
_root_dir:
	call	kjt_root_dir
	jp   flos_err
