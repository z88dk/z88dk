;
;	Memotech MTX stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: fgetc_cons.asm,v 1.3+ (now on GIT) $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	call	$79
	jr	z,fgetc_cons
  
IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret
