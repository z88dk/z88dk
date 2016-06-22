;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;
;	$Id: create_file.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  create_file
	PUBLIC  _create_file
	EXTERN   flos_err

create_file:
_create_file:
	; __FASTCALL__
	call	kjt_create_file
	jp	flos_err
