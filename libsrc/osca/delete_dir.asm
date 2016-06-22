;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;
;	$Id: delete_dir.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  delete_dir
	PUBLIC  _delete_dir
	EXTERN   flos_err
	
delete_dir:
_delete_dir:
	; __FASTCALL__
	call	kjt_delete_dir
	jp   flos_err
