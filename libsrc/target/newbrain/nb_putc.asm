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
; $Id: nb_putc.asm,v 1.3 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC nb_putc
	PUBLIC _nb_putc
	
	EXTERN ZCALL

.nb_putc
._nb_putc
	push	ix	;save callers

	ld	ix,4
	add	ix,sp

	ld	a,(ix+0)	; byte
	ld	e,(ix+2)	; stream
	
	call	ZCALL
	defb	$30	; zoutput
	pop	ix
	ret
