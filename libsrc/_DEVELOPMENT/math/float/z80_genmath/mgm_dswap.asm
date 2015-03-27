;
;       Z88dk Generic Floating Point Math Library
;
;       Exchange FA with top of stack (under ret address)
;
;	$Id: mgm_dswap.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $


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


