;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Create directory
;
;	$Id: make_dir.asm,v 1.1 2012-10-15 10:40:46 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  make_dir
	LIB   flos_err
	
make_dir:
	call	kjt_make_dir
	jp      flos_err
