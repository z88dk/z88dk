;
;	Amstrad CPC Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: getk.asm,v 1.2 2002-04-17 21:30:26 dom Exp $
;

	XLIB	getk

.getk
	call	$BB06
	ld	h,0
	ld	l,a
	ret
