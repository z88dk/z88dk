;
;	Devilishly simple routines for the Spectrum
;
;	puts(char *s) - put string to screen
;
;
;	$Id: puts_cons.asm,v 1.1 2007-10-07 17:49:34 dom Exp $
;


		XLIB	puts_cons
		LIB	fputc_cons


; Enter in with hl holding the address of string to print

.puts_cons
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
	ld	e,13
	push	de
	call	fputc_cons
	pop	de
	ret

