;
;       ZX Maths Routines
;
;       Borrowed from the Generic Floating Point Math Library
;
;       Exchange FA with top of stack (under ret address)
;
;	$Id: dswap.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $


		PUBLIC	dswap
		
		EXTERN	ldfabc

		EXTERN	dpush

.dswap  POP     HL      ;return addr
        POP     DE
        POP     IX
        POP     BC
        EXX             ;protect the values
        CALL    dpush   ;push FA
        EXX             ;recover the values
        PUSH    HL      ;replace return addr, fall into...
        jp      ldfabc

