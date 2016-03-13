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
;	$Id: puts_cons.asm,v 1.4 2016-03-13 18:14:13 dom Exp $
;



		SECTION	  code_clib

                PUBLIC    puts_cons


.puts_cons
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	ix
	ld	c,$5c		;PCHARS
	rst	$10
	pop	ix
	ret
