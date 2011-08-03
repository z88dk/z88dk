;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Like 'remove' but with a FLOS style error handling
;
;	$Id: erase_file.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  erase_file
	LIB   flos_err
	
erase_file:
	; __FASTCALL__
	call	kjt_erase_file
	jp   flos_err
