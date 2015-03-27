;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: mgm_dleq.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:

		PUBLIC	dleq

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dleq	call dcompar
	jp	z,f_yes
	jp	p,f_yes
	jp	f_no

