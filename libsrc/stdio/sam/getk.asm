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
;	$Id: getk.asm,v 1.4 2015-01-19 01:33:21 pauloscustodio Exp $
;



		PUBLIC	getk

.getk
		call	$0169
		ld	h,0
		jr	nz,gotkey
		ld	l,h
		ret
.gotkey
		ld	l,a
		ret
