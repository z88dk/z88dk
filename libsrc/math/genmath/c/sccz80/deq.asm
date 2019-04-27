;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: deq.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	deq

	EXTERN	dcompar
	EXTERN	f_yes
	EXTERN	f_no

.deq	call dcompar
	jp	z,f_yes
	jp	f_no

