;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Enter in current directory entry
;
;	$Id: change_dir.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

	SECTION	code_clib
	PUBLIC  change_dir
	PUBLIC  _change_dir
	EXTERN   flos_err
	
change_dir:
_change_dir:
	call	kjt_change_dir
	jp      flos_err
