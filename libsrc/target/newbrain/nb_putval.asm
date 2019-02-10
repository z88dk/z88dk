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
; $Id: nb_putval.asm,v 1.4 2017-01-02 23:31:08 aralbrec Exp $
;

        SECTION code_clib
	PUBLIC nb_putval
	PUBLIC _nb_putval
	
	EXTERN ZCALL


.nb_putval
._nb_putval
	push	ix		;save callers
	ld	ix,4
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
	pop	ix
	ret

	SECTION	bss_clib
.fpstore
	defs	6
