;
;	MSX C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.5 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	getk
	LIB	fgetc_cons
        LIB	msxbios


IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
ENDIF


.getk
	ld	ix,CHSNS
	call	msxbios
	ret	z		; exit if no key in buffer
	jp	fgetc_cons
