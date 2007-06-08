;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; put a byte block to stream, return the number of written bytes
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; int nb_putblock( int stream, char *bytes, int length );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_putblock.asm,v 1.3 2007-06-08 15:15:21 stefano Exp $
;


	XLIB nb_putblock
	
	LIB ZCALL

.nb_putblock

	ld	ix,2
	add	ix,sp

	ld	e,(ix+4)	; stream

	ld	c,(ix+0)	; block length
	ld	b,(ix+1)

	ld	l,(ix+2)	; block location
	ld	h,(ix+3)

	call	ZCALL
	defb	$3d	; zblkout
	
	ld	h,b
	ld	l,c

	ret
