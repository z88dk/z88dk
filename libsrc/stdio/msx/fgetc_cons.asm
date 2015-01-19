;
;	MSX C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2001
;
;
;	$Id: fgetc_cons.asm,v 1.7 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons
        EXTERN	msxbios


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
