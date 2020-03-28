;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dleq.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	dleq

	EXTERN	dcompar
	EXTERN	f_yes
	EXTERN	f_no

.dleq	call dcompar
	jp	z,f_yes
	jp	p,f_yes
	jp	f_no

