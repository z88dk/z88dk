;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.1 2001-05-21 09:48:43 stefano Exp $
;

	XLIB	getk

.getk
	call	$845
	ld	h,0
	ld	l,a
	ret
