;
;	MSX C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.4 2007-12-07 11:28:59 stefano Exp $
;

	XLIB	getk
	LIB	fgetc_cons
        LIB	msxbios

        INCLUDE "#msxbios.def"

.getk
	ld	ix,CHSNS
	call	msxbios
	ret	z		; exit if no key in buffer
	jp	fgetc_cons
