;
;       Z88dk Generic Floating Point Math Library
;
;	TOS >= FA
;
;       $Id: dge.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	dge

	EXTERN	dcompar
	EXTERN	f_yes
	EXTERN	f_no

.dge	call dcompar
	jp	z,f_yes
	jp	p,f_no
	jp	f_yes

