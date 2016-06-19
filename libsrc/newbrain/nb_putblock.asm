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
; $Id: nb_putblock.asm,v 1.5 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC nb_putblock
	PUBLIC _nb_putblock
	
	EXTERN ZCALL

.nb_putblock
._nb_putblock
	push	ix		;save callers
	ld	ix,4
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
	pop	ix
	ret
