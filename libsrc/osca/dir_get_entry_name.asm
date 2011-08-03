;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get filename associated to current directory entry
;
;	$Id: dir_get_entry_name.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  dir_get_entry_name
	
dir_get_entry_name:
	push iy
	call	kjt_dir_list_get_entry
	pop iy
	ret
