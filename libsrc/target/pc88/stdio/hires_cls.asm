; Clear all 3 colour planes
;


	SECTION	code_clib

	PUBLIC	hires_cls

	EXTERN	l_push_di
	EXTERN	l_pop_ei

hires_cls:
	call	l_push_di
	out	($5c),a		;Switch to green
	call	clear_plane
	out	($5d),a		;Switch to red
	call	clear_plane
	out	($5e),a		;Switch to blue
	call	clear_plane
	out	($5f),a		;Back to main memory
	call	l_pop_ei
	ret

clear_plane:
	ld	hl,$c000
	ld	de,$c001
	ld	bc,15999	;80x200 - 1
	ld	(hl),0
	ldir
	ret

