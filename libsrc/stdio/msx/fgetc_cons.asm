;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;
;
;	$Id: fgetc_cons.asm,v 1.3 2007-12-03 07:29:40 stefano Exp $
;

	XLIB	fgetc_cons
	LIB	msxbios

.fgetc_cons
	ld	ix,$9f
	call	msxbios
	ld	l,a
	ld	h,0
	ret
