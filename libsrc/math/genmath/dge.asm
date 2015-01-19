;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dge.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	dge

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dge	call dcompar
	jp	z,f_yes
	jp	p,f_no
	jp	f_yes

