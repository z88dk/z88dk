;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; get a block from stream, return with the number of read bytes
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int nb_getblock( int stream, char *bytes, int length );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_getblock.asm,v 1.2 2007-06-08 15:15:21 stefano Exp $
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

	push	bc
	
	call	ZCALL
	defb	$3c	; zblkin
	
	and	a
	pop	hl
	sbc	hl,bc
	
	ret
