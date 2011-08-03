;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: parent_dir.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  parent_dir
	LIB   flos_err

parent_dir:
	call	kjt_parent_dir
	jp   flos_err
