;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.2 2002-04-17 21:30:26 dom Exp $
;

	XLIB	getk

.getk
	call	$845
	ld	h,0
	ld	l,a
	ret
