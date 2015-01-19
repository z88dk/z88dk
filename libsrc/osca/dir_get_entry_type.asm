;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get file type associated to current directory entry
;	0 = file
;	1 = dir
;
;	$Id: dir_get_entry_type.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;

    INCLUDE "flos.def"

	PUBLIC  dir_get_entry_type
	
dir_get_entry_type:
	push iy
	call	kjt_dir_list_get_entry
	ld	h,0
	ld	l,b
	pop iy
	ret
