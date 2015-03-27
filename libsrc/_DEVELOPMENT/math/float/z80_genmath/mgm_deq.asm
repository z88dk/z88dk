;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: mgm_deq.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:

		PUBLIC	deq

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.deq	call dcompar
	jp	z,f_yes
	jp	f_no

