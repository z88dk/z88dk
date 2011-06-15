;
;	Keyboard routines for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2011-06-15 20:15:00 stefano Exp $
;

		XLIB	fgetc_cons

.fgetc_cons
	xor	a
	call $C90A
	jr	z,fgetc_cons
	ret
