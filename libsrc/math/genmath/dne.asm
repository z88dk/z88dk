;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dne.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:


        SECTION code_fp
	PUBLIC	dne

	EXTERN	dcompar
	EXTERN	f_yes
	EXTERN	f_no

.dne	call dcompar
	jp	nz,f_yes
	jp	f_no

