;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2012
;
;	Get name of current directory
;
;	$Id: get_dir_name.asm,v 1.3 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  get_dir_name
	
get_dir_name:
	jp	kjt_get_dir_name
