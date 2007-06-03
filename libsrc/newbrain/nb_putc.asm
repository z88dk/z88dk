;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; put char to stream
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; void nb_putc( int stream, char byte );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_putc.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;


	XLIB nb_putc
	
	LIB ZCALL

.nb_putc

	ld	ix,2
	add	ix,sp

	ld	a,(ix+0)	; byte
	ld	e,(ix+2)	; stream
	
	call	ZCALL
	defb	$30	; zoutput

	ret
