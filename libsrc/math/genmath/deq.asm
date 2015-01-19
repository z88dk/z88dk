;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: deq.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	deq

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.deq	call dcompar
	jp	z,f_yes
	jp	f_no

