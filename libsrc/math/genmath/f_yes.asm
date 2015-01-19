;
;       Z88dk Generic Floating Point Math Library
;
;	Return true
;
;       $Id: f_yes.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	f_yes

.f_yes
	ld	hl,1
	scf	
	ret

