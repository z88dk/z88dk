;

		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons
 
		EXTERN	LASTKEYPRSD

.fgetc_cons
._fgetc_cons
	ld	hl,32768
loop:
	dec	hl
	ld	a,h
	or	l
	jr	nz,loop
.getkey1
	ld	a,(LASTKEYPRSD)
	and	a
	jr	z,getkey1
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF
	ld	l,a
	ld	h,0
	ret
