;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; put a byte block to stream
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; void nb_getblock( int stream, char *bytes, int length );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_getblock.asm,v 1.1 2007-06-07 08:23:09 stefano Exp $
;


	XLIB nb_getblock
	
	LIB ZCALL

.nb_getblock

	ld	ix,2
	add	ix,sp

	ld	e,(ix+4)	; stream

	ld	c,(ix+0)	; block length
	ld	b,(ix+1)

	ld	l,(ix+2)	; block location
	ld	h,(ix+3)

	call	ZCALL
	defb	$3c	; zblkin
	
	ret
