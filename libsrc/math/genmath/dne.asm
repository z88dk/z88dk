;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dne.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	dne

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dne	call dcompar
	jp	nz,f_yes
	jp	f_no

