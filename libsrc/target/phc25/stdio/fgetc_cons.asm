;
;	stdio - Sanyo PHC-25
;
;	getkey(), wait for keypress
;
;
;
;	$Id: fgetc_cons.asm $
;


		SECTION	code_clib
		PUBLIC	fgetc_cons
		PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons

.getkey1
	ld	a,($F95C)
	and	a
	jr	z,getkey1

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	cp  29
	jr  nz,nobs
	ld	a,8
.nobs

	ld	l,a
	xor a
	ld	h,a
	ld	($F95C),a

	ret
