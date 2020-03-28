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
; $Id: nb_puts.asm,v 1.3 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC nb_puts
	PUBLIC _nb_puts
	
	EXTERN ZCALL

.nb_puts
._nb_puts
	push	ix		;save callers
	ld	ix,4
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
	pop	ix

	ret
