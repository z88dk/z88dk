;
;	Old School Computer Architecture - interfacing FLOS
;	Stefano Bodrato, 2011
;
;	Get the first sector used by a file
;
;	$Id: get_first_file_cluster.asm,v 1.5 2016-06-22 22:13:09 dom Exp $
;

    INCLUDE "flos.def"

        SECTION code_clib
	PUBLIC  get_first_file_cluster
	PUBLIC  _get_first_file_cluster
	
get_first_file_cluster:
_get_first_file_cluster:
; __FASTCALL__, HL points to filename
	push	ix	;save callers
	push	iy
	call	kjt_find_file
	push	ix
	pop		de
	push	iy
	pop		hl
	pop		iy
	pop	ix	;restore callers
	ret	z

	ld	hl,0
	ld	d,h
	ld	e,l
	ret
