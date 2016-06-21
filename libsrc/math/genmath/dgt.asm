;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dgt.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	dgt

	EXTERN	dcompar
	EXTERN	f_yes
	EXTERN	f_no

.dgt	call dcompar
	jp	z,f_no
	jp	p,f_no
	jp	f_yes

