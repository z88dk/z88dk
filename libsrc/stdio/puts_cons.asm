;
;	Devilishly simple routines for the Spectrum
;
;	puts(char *s) - put string to screen
;
;
;	$Id: puts_cons.asm,v 1.7 2016-07-02 13:52:42 dom Exp $
;

		MODULE puts_cons_native
		SECTION	code_clib
		PUBLIC	puts_cons_native
		EXTERN	fputc_cons


; Enter in with hl holding the address of string to print

.puts_cons_native
	pop	bc
	pop	hl
	push	hl
	push	bc
	push    ix
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
	pop	ix
	ret

