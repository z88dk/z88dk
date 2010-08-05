;
;	Memotech MTX stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - Aug. 2010
;
;
;	$Id: getk.asm,v 1.1 2010-08-05 06:14:09 stefano Exp $
;

	XLIB	getk

.getk
	call	$79
	ld	h,0
	ld	l,a
	ret
