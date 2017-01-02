;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: parent_dir.asm,v 1.4 2017-01-02 23:35:59 aralbrec Exp $
;

    INCLUDE "flos.def"

	SECTION code_clib
	PUBLIC  parent_dir
   PUBLIC  _parent_dir
	EXTERN   flos_err

parent_dir:
_parent_dir:
	call	kjt_parent_dir
	jp   flos_err
