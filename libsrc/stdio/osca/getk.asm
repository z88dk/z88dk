;
; 	Basic keyboard handling for the OSCA architecture
;	By Stefano Bodrato Jul. 2011
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2011-07-26 13:24:27 stefano Exp $
;


    INCLUDE "flos.def"

	XLIB	getk

.getk
	call kjt_get_key
	or a
	jr nz,knz
	ld	b,a
.knz
	ld	l,b	; ASCII CODE
	ld	h,0

	ret
