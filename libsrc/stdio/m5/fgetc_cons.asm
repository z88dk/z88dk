;
;	SORD M5 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.1 2001-05-21 09:48:43 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons
	call	$845
	ld	h,0
	ld	l,a
	ret
