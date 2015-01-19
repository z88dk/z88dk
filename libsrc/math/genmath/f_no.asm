;
;       Z88dk Generic Floating Point Math Library
;
;	Return true
;
;       $Id: f_no.asm,v 1.2 2015-01-19 01:32:56 pauloscustodio Exp $:

		PUBLIC	f_no

.f_no
	ld	hl,0
	and	a
	ret

