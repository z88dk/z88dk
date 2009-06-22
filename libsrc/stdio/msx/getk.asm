;
;	MSX C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.6 2009-06-22 21:44:17 dom Exp $
;

	XLIB	getk
	LIB	fgetc_cons
        LIB	msxbios


IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


.getk
	ld	ix,CHSNS
	call	msxbios
	ret	z		; exit if no key in buffer
	jp	fgetc_cons
