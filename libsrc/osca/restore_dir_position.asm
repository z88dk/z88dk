;
;	Get the FLOS version number
;	by Stefano Bodrato, 2011
;
;
;
;	$Id: restore_dir_position.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  restore_dir_position
	
restore_dir_position:
	jp	kjt_restore_dir_position
