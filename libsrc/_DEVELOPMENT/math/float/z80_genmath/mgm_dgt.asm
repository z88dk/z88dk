;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: mgm_dgt.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:

		PUBLIC	dgt

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dgt	call dcompar
	jp	z,f_no
	jp	p,f_no
	jp	f_yes

