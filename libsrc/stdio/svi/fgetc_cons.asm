;
;	Spectravideo SVI C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;
;
;	$Id: fgetc_cons.asm,v 1.2 2001-04-13 14:14:00 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons
	call	$3e
	ld	l,a
	ld	h,0
	ret
