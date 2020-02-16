
	SECTION	code_clib

	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons


fgetc_cons:
_fgetc_cons:
	call	$85
	and	a
	jr	z,fgetc_cons
	ld	l,a
	ld	h,0
	ret
