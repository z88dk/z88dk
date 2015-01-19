;
;	ABC80 Routines
;
;	getk() Read key status
;
;	Maj 2000 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.4 2015-01-19 01:33:17 pauloscustodio Exp $
;

	PUBLIC	getk

.getk
	in	a,(56)
	and 127
	ld	l,a
	ld	h,0
	ret
