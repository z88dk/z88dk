;
;	Amstrad CPC Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fgetc_cons.asm,v 1.2 2002-04-17 21:30:26 dom Exp $
;

	XLIB	fgetc_cons

.fgetc_cons

	call	$BB06
	ld	h,0
	ld	l,a
	ret
