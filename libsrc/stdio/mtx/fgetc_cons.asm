;
;	Memotech MTX stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: fgetc_cons.asm,v 1.1 2010-08-05 06:14:09 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons
	call	$79
	jr	z,fgetc_cons
	ld	h,0
	ld	l,a
	ret
