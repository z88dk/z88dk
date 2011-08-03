;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Enter in current directory entry
;
;	$Id: change_dir.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  change_dir
	LIB   flos_err
	
change_dir:
	call	kjt_change_dir
	jp      flos_err
