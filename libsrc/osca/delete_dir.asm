;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;
;	$Id: delete_dir.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  delete_dir
	LIB   flos_err
	
delete_dir:
	; __FASTCALL__
	call	kjt_delete_dir
	jp   flos_err
