;
;	Devilishly simple routines for the Spectrum
;
;	puts(char *s) - put string to screen
;
;
;	$Id: puts_cons.asm,v 1.5 2016-04-29 20:35:38 dom Exp $
;


		SECTION	code_clib
		PUBLIC	puts_cons
		PUBLIC	_puts_cons
		EXTERN	fputc_cons


; Enter in with hl holding the address of string to print

.puts_cons
._puts_cons
	pop	bc
	pop	hl
	push	hl
	push	bc
.puts0
	ld	a,(hl)
	and	a
	jr	z,puts1
	push	hl
	ld	e,a
	push	de
	call	fputc_cons
	pop	de
	pop	hl
	inc	hl
	jr	puts0
.puts1
IF STANDARDESCAPECHARS
	ld	e,10
ELSE
	ld	e,13
ENDIF
	push	de
	call	fputc_cons
	pop	de
	ret

