;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get filename associated to current directory entry
;
;	$Id: dir_get_entry_name.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  dir_get_entry_name
	PUBLIC  _dir_get_entry_name
	
dir_get_entry_name:
_dir_get_entry_name:
	push iy
	call	kjt_dir_list_get_entry
	pop iy
	ret
