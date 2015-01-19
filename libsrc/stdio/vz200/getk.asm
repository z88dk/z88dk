;
;	Devilishly simple VZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;


		PUBLIC	getk

.getk
		call	12020		;scan keyboard once
		ld	l,a
		ld	h,0
		ret
