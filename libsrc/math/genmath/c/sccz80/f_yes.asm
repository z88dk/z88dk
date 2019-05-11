;
;       Z88dk Generic Floating Point Math Library
;
;	Return true
;
;       $Id: f_yes.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	f_yes

.f_yes
	ld	hl,1
	scf	
	ret

