;
;	SORD M5 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.2 2002-04-17 21:30:26 dom Exp $
;

	XLIB	fgetc_cons

.fgetc_cons
	call	$845
	ld	h,0
	ld	l,a
	ret
