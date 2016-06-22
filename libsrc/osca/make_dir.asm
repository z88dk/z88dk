;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Create directory
;
;	$Id: make_dir.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  make_dir
	PUBLIC  _make_dir
	EXTERN   flos_err
	
make_dir:
_make_dir:
	call	kjt_make_dir
	jp      flos_err
