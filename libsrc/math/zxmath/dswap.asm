;
;       ZX Maths Routines
;
;       Borrowed from the Generic Floating Point Math Library
;
;       Exchange FA with top of stack (under ret address)
;
;	$Id: dswap.asm,v 1.2 2014-04-11 11:14:01 stefano Exp $


		XLIB	dswap
		
		LIB	ldfabc

		XREF	dpush

.dswap  POP     HL      ;return addr
        POP     DE
        POP     IX
        POP     BC
        EXX             ;protect the values
        CALL    dpush   ;push FA
        EXX             ;recover the values
        PUSH    HL      ;replace return addr, fall into...
        jp      ldfabc

