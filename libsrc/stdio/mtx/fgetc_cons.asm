;
;	Memotech MTX stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
	call	$79
	jr	z,fgetc_cons
	ld	h,0
	ld	l,a
	ret
