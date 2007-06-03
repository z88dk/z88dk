;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; put a string to stream
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; void nb_puts( int stream, char *text );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_puts.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;


	XLIB nb_puts
	
	LIB ZCALL

.nb_puts

	ld	ix,2
	add	ix,sp

	ld	e,(ix+2)	; stream

	ld	l,(ix+0)	; string
	ld	h,(ix+1)

	;parameter string length count
	ld	bc,0
	push	hl
.strct
	ld	a,(hl)
	and	a
	jr	z,strcount
	inc	hl
	inc	bc
	jr	strct
.strcount
	pop	hl
	
	call	ZCALL
	defb	$3d	; zblkout


	ret
