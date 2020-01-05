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
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.getk
._getk
	push	ix
	ld	ix,CHSNS
	call	msxbios
	pop	ix
        ld      hl,0
	ret	z		; exit if no key in buffer
	jp	fgetc_cons
