;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: mgm_dge.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:

		PUBLIC	dge

		EXTERN	dcompar
		EXTERN	f_yes
		EXTERN	f_no

.dge	call dcompar
	jp	z,f_yes
	jp	p,f_no
	jp	f_yes

