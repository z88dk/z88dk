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
;	$Id: puts_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;

                INCLUDE "stdio.def"

                PUBLIC    puts_cons


.puts_cons
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	c,$5c		;PCHARS
	rst	$10
	ret
