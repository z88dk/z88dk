;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get file type associated to current directory entry
;	0 = file
;	1 = dir
;
;	$Id: dir_get_entry_type.asm,v 1.3 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  dir_get_entry_type
	PUBLIC  _dir_get_entry_type
	
dir_get_entry_type:
_dir_get_entry_type:
	push iy
	call	kjt_dir_list_get_entry
	ld	h,0
	ld	l,b
	pop iy
	ret
