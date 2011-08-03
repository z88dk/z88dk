;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;
;	$Id: create_file.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  create_file
	LIB   flos_err

create_file:
	; __FASTCALL__
	call	kjt_create_file
	jp	flos_err
