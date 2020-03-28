;
;       Z88dk Generic Floating Point Math Library
;
;	Return true
;
;       $Id: f_no.asm,v 1.3 2016-06-21 21:16:49 dom Exp $:

        SECTION code_fp
	PUBLIC	f_no

.f_no
	ld	hl,0
	and	a
	ret

