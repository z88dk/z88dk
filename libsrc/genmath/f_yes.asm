;
;       Z88dk Generic Floating Point Math Library
;
;	Return true
;
;       $Id: f_yes.asm,v 1.1 2002-01-21 20:35:22 dom Exp $:

		XLIB	f_yes

.f_yes
	ld	hl,1
	scf	
	ret

