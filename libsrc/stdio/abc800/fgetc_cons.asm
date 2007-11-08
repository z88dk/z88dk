;
;	ABC800 Routines
;
;	getkey() Wait for keypress
;
;	Oct. 2007 - Stefano Bodrato
;
;
;	$Id: fgetc_cons.asm,v 1.1 2007-11-08 14:11:50 stefano Exp $
;

	XLIB	fgetc_cons

.fgetc_cons
	call	2

	ld	l,a
	ld	h,0
	ret
