;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;
;
;	$Id: fgetc_cons.asm,v 1.5 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	fgetc_cons
        LIB	msxbios


IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
ENDIF


.fgetc_cons
	ld	ix,CHGET
	call	msxbios
	ld	l,a
	ld	h,0
	ret
