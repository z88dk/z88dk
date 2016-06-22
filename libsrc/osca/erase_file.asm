;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'remove' but with a FLOS style error handling
;
;	$Id: erase_file.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  erase_file
	PUBLIC  _erase_file
	EXTERN   flos_err
	
erase_file:
_erase_file:
	; __FASTCALL__
	call	kjt_erase_file
	jp   flos_err
