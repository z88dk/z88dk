;
; 	Basic keyboard handling for the OSCA architecture
;	By Stefano Bodrato Jul. 2011
;
;	getkey() Wait for keypress
;
;
;	$Id: fgetc_cons.asm,v 1.1 2011-07-26 13:24:27 stefano Exp $
;


    INCLUDE "flos.def"

	XLIB	fgetc_cons

.fgetc_cons

.kwait

	call kjt_get_key
	or a
	jr z,kwait
	
	ld	l,b	; ASCII CODE
	ld	h,0

	ret
