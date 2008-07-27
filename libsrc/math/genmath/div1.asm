;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: div1.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $

		XLIB	div1

		LIB	fdiv

.DIV1   POP     BC
        POP     IX
        POP     DE
        jp      FDIV

