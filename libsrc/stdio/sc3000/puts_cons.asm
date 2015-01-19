;
;   SEGA SC-3000 C Library
;
;	Print string to the screen
;
;	$Id: puts_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;


		PUBLIC	puts_cons


; Enter in with hl holding the address of string to print

.puts_cons
	pop	bc
	pop	hl
	push	hl
	push	bc
	jp	$4A6F
