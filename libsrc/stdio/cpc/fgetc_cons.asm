;
;	Amstrad CPC Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 8/6/2001
;
;
;	$Id: fgetc_cons.asm,v 1.1 2001-06-12 14:28:47 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons

	call	$BB06
	ld	h,0
	ld	l,a
	ret
