;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dleq.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	dleq

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dleq	call dcompar
	jp	z,f_yes
	jp	p,f_yes
	jp	f_no

