;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;
;
;	$Id: fgetc_cons.asm,v 1.4 2007-12-07 11:28:59 stefano Exp $
;

	XLIB	fgetc_cons
        LIB	msxbios

        INCLUDE "#msxbios.def"

.fgetc_cons
	ld	ix,CHGET
	call	msxbios
	ld	l,a
	ld	h,0
	ret
