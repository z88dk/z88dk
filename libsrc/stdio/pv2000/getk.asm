

		SECTION	code_clib
		PUBLIC	getk
		PUBLIC	_getk
		EXTERN	in_Inkey

.getk
._getk
	call	in_Inkey
	ret	c
IF STANDARDESCAPECHARS
	ld	a,l
	cp	13
	jr	nz,not_return
	ld	l,10
.not_return
ENDIF
	ret
