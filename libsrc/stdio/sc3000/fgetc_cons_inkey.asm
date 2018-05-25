

		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons
		EXTERN	in_GetKey

.fgetc_cons
._fgetc_cons
	call	in_GetKey
	jr	c,fgetc_cons
IF STANDARDESCAPECHARS
	ld	a,l
	cp	13
	jr	nz,not_return
	ld	l,10
.not_return
ENDIF
	ret
