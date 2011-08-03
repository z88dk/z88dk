;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	$Id: check_volume_format.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  check_volume_format
	LIB   flos_err
	
check_volume_format:
	call	kjt_check_volume_format
	jp   flos_err
