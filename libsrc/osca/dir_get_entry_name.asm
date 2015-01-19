;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get filename associated to current directory entry
;
;	$Id: dir_get_entry_name.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  dir_get_entry_name
	
dir_get_entry_name:
	push iy
	call	kjt_dir_list_get_entry
	pop iy
	ret
