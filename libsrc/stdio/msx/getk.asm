;
;	MSX C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.9 2016-06-12 17:07:44 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk
	EXTERN	fgetc_cons
        EXTERN	msxbios


IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


.getk
._getk
	ld	ix,CHSNS
	call	msxbios
	ret	z		; exit if no key in buffer
	jp	fgetc_cons
