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
; $Id: nb_puts.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC nb_puts
	
	EXTERN ZCALL

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
