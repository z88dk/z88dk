;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 06/06/2007
;
;
; - - - - - - - - - - - - - - - - - - - - -
;
; get a string from stream
;
; - - - - - - - - - - - - - - - - - - - - -
;
; char *nb_gets( int stream, char *bytes );
;
; - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_gets.asm,v 1.1 2007-06-08 15:15:21 stefano Exp $
;


	XLIB nb_gets
	
	LIB ZCALL

.nb_gets

	ld	ix,2
	add	ix,sp

	ld	e,(ix+2)	; stream

	ld	l,(ix+0)	; block location
	ld	h,(ix+1)
	
	push	hl
	ld	bc,255		; read max 255 bytes

	call	ZCALL
	defb	$3c		; zblkin
	
	ld	a,255
	sub	c		; number of read bytes
	ld	e,a
	ld	d,0
	
	pop	hl
	push	hl
	add	hl,de
	dec	hl		; we overwrite the last <CR>
	ld	(hl),d		; with zero

	pop	hl

	ret
	