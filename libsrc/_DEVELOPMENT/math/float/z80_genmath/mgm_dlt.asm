;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: mgm_dlt.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:

		PUBLIC	dlt

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dlt	call dcompar
	jp	z,f_no
	jp	p,f_yes
	jp	f_no

