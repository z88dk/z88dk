;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get the first sector used by a file
;
;	$Id: get_first_file_cluster.asm,v 1.3 2012-03-08 07:16:46 stefano Exp $
;

    INCLUDE "flos.def"

	XLIB  get_first_file_cluster
	
get_first_file_cluster:
; __FASTCALL__, HL points to filename
	push	iy
	call	kjt_find_file
	push	ix
	pop		de
	push	iy
	pop		hl
	pop		iy
	ret	z

	ld	hl,0
	ld	d,h
	ld	e,l
	ret
