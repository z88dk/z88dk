;
;   SEGA SC-3000 C Library
;
;	getkey() Wait for keypress
;
;	$Id: fgetc_cons.asm,v 1.1 2010-06-24 09:05:51 stefano Exp $
;

		XLIB	fgetc_cons

.fgetc_cons
	call	$42D4
	ld	l,a
	ld	h,0
	ret
