;
;       Z88dk Generic Floating Point Math Library
;
;	Return true
;
;       $Id: mgm_f_yes.asm,v 1.1 2015-03-27 06:03:28 aralbrec Exp $:

		PUBLIC	f_yes

.f_yes
	ld	hl,1
	scf	
	ret

