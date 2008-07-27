;
;       Z88dk Generic Floating Point Math Library
;
;	Return true
;
;       $Id: f_yes.asm,v 1.1 2008-07-27 21:44:57 aralbrec Exp $:

		XLIB	f_yes

.f_yes
	ld	hl,1
	scf	
	ret

