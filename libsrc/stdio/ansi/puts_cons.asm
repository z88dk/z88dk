;
;       Z80 ANSI Library
;
;---------------------------------------------------
;       Optimized puts_cons for the ANSI lib
;
;	Stefano Bodrato - 3/4/2001
;


		XLIB	puts_cons
		LIB	f_ansi


; Enter in with hl holding the address of string to print

.puts_cons
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
