;
;       Z80 ANSI Library
;
;---------------------------------------------------
;       Optimized puts_cons for the ANSI lib
;
;	Stefano Bodrato - 3/4/2001
;
;	$Id: puts_cons.asm,v 1.5 2016-04-04 18:31:22 dom Exp $
;

		SECTION	code_clib
		PUBLIC	puts_cons
		PUBLIC	_puts_cons
		EXTERN	f_ansi


; Enter in with hl holding the address of string to print

.puts_cons
._puts_cons
	pop	bc
	pop	hl
	push	hl
	push	bc

	push	hl
	ld	b,255
	ld	c,b
	xor	a
	cpir		; Locate the string termination
	
	pop	de
	push	de
	scf
	sbc	hl,de	; Compute the number of chars to be printed
	pop	de
	ex	de,hl
	
	jp	f_ansi
