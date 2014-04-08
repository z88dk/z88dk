;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: div1.asm,v 1.2 2014-04-08 07:06:20 stefano Exp $

		XLIB	div1

		LIB	fdiv

.div1   POP     BC
        POP     IX
        POP     DE
        jp      fdiv

