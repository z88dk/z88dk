
		MODULE	fgetc_cons
		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons


fgetc_cons:
_fgetc_cons:
	call	$70f
	ld	hl,0
	jr	z,fgetc_cons
	and	a
	jr	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret

		
