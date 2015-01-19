;
;	Memotech MTX stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons

.fgetc_cons
	call	$79
	jr	z,fgetc_cons
	ld	h,0
	ld	l,a
	ret
