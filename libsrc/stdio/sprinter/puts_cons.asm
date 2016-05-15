;
;       Small C+ Z88 Internal Routine
;       Puts a string to the console - mapping \n to \n\l as we
;       go and appending \n\l to the end of the line
;
;	Non standard (for short programs)
;
;       djm 2/4/99
;
;
;	$Id: puts_cons.asm,v 1.5 2016-05-15 20:15:46 dom Exp $
;



		SECTION	  code_clib

                PUBLIC    puts_cons_native


.puts_cons_native
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	ld	c,$5c		;PCHARS
	rst	$10
	pop	ix
	ret
