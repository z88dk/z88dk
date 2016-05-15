;
;   SEGA SC-3000 C Library
;
;	Print string to the screen
;
;	$Id: puts_cons.asm,v 1.3 2016-05-15 20:15:46 dom Exp $
;

		SECTION code_clib
		PUBLIC	puts_cons_native


; Enter in with hl holding the address of string to print

.puts_cons_native
	pop	bc
	pop	hl
	push	hl
	push	bc
	jp	$4A6F
