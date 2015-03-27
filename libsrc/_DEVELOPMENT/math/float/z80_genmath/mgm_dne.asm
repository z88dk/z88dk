;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: mgm_dne.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:

		PUBLIC	dne

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dne	call dcompar
	jp	nz,f_yes
	jp	f_no

