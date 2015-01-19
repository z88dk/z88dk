;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: div1.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $

		PUBLIC	div1

		EXTERN	fdiv

.div1   POP     BC
        POP     IX
        POP     DE
        jp      fdiv

