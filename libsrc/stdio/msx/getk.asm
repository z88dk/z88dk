;
;	MSX C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.7 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	getk
	EXTERN	fgetc_cons
        EXTERN	msxbios


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
