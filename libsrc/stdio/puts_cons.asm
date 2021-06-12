;
;	Devilishly simple routines for the Spectrum
;
;	puts(char *s) - put string to screen
;
;
;	$Id: puts_cons.asm,v 1.7 2016-07-02 13:52:42 dom Exp $
;

		MODULE puts_cons
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
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	push    ix
ENDIF
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
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	pop	ix
ENDIF
	ret

