;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dlt.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	dlt

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dlt	call dcompar
	jp	z,f_no
	jp	p,f_yes
	jp	f_no

