
	SECTION	code_clib

	PUBLIC	getk
	PUBLIC	_getk


getk:
_getk:
	call	$85
	ld	l,a
	ld	h,0
	ret
