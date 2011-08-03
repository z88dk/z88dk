;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: root_dir.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  root_dir
	LIB   flos_err
	
root_dir:
	call	kjt_root_dir
	jp   flos_err
