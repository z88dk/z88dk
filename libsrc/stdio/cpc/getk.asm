;
;	Amstrad CPC Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: getk.asm,v 1.1 2001-06-12 14:28:47 stefano Exp $
;

	XLIB	getk

.getk
	call	$BB06
	ld	h,0
	ld	l,a
	ret
