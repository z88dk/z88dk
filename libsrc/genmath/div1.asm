;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: div1.asm,v 1.1 2002-01-21 20:35:22 dom Exp $

		XLIB	div1

		LIB	fdiv

.DIV1   POP     BC
        POP     IX
        POP     DE
        jp      FDIV

