;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: div1.asm,v 1.4 2016-06-21 21:16:49 dom Exp $

        SECTION code_fp
	PUBLIC	div1

	EXTERN	fdiv

.div1   POP     BC
        POP     IX
        POP     DE
        jp      fdiv

