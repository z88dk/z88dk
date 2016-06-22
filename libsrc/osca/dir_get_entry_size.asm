;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get file size (long) associated to current directory entry
;
;	$Id: dir_get_entry_size.asm,v 1.5 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  dir_get_entry_size
	PUBLIC  _dir_get_entry_size
	
dir_get_entry_size:
_dir_get_entry_size:
	push	ix	;save callers
;	push	iy
	call	kjt_dir_list_get_entry
	push	ix
	pop	de
	push	iy
	pop	hl
;	pop	iy
	pop	ix	;restore callers
	ret	z
	ld	hl,0
	ld	d,h
	ld	e,l
	ret
