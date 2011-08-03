;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get file type associated to current directory entry
;	0 = file
;	1 = dir
;
;	$Id: dir_get_entry_type.asm,v 1.1 2011-08-03 08:13:40 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  dir_get_entry_type
	
dir_get_entry_type:
	push iy
	call	kjt_dir_list_get_entry
	ld	h,0
	ld	l,b
	pop iy
	ret
