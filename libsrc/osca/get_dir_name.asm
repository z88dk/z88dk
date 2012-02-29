;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	Get name of current directory
;
;	$Id: get_dir_name.asm,v 1.1 2012-02-29 07:03:53 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_dir_name
	
get_dir_name:
	jp	kjt_get_dir_name
