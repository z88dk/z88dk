;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 19/05/2007
;
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; put int value to stream, converting to float
;     
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; void nb_putval( int stream, int value );
;
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
;
; $Id: nb_putval.asm,v 1.2 2015-01-19 01:33:00 pauloscustodio Exp $
;


	PUBLIC nb_putval
	
	EXTERN ZCALL

.fpstore
	defs	6

.nb_putval
	ld	ix,2
	add	ix,sp

	ld	e,(ix+0)	; value
	ld	d,(ix+1)
	call	ZCALL
	defb	$28	; zflt
	
	ld	hl,fpstore
	push	hl
	call	ZCALL
	defb	$2d	; zstf
	pop	hl

	ld	e,(ix+2)	; stream

	ld	b,6
.outloop
	ld	a,(hl)
	call	ZCALL
	defb	$30	; zoutput
	djnz	outloop

	ret
