;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get file size (long) associated to current directory entry
;
;	$Id: dir_get_entry_size.asm,v 1.2 2012-03-05 20:40:15 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  dir_get_entry_size
	
dir_get_entry_size:
;	push	iy
	call	kjt_dir_list_get_entry
	push	ix
	pop		de
	push	iy
	pop		hl
;	pop		iy
	ret	z

	ld	hl,0
	ld	d,h
	ld	e,l
	ret
