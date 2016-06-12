;
;       SAM Coupe C Library
;
;	getk() Read key status
;
;       We will corrupt any register
;
;       Stefano Bodrato - Mar.2001
;
;
;	$Id: getk.asm,v 1.5 2016-06-12 17:32:01 dom Exp $
;



        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
		call	$0169
		ld	h,0
		jr	nz,gotkey
		ld	l,h
		ret
.gotkey
		ld	l,a
		ret
