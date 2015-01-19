;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dgt.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	dgt

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dgt	call dcompar
	jp	z,f_no
	jp	p,f_no
	jp	f_yes

