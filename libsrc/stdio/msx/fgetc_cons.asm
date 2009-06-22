;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;
;
;	$Id: fgetc_cons.asm,v 1.6 2009-06-22 21:44:17 dom Exp $
;

	XLIB	fgetc_cons
        LIB	msxbios


IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


.fgetc_cons
	ld	ix,CHGET
	call	msxbios
	ld	l,a
	ld	h,0
	ret
