;
;       Z88dk Generic Floating Point Math Library
;
;
;	$Id: mgm_div1.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $

		PUBLIC	div1

		EXTERN	fdiv

.div1   POP     BC
        POP     IX
        POP     DE
        jp      fdiv

