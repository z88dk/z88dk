;
;	Mattel AQUARIUS Routines
;
;	getk() Read key status
;
;	Dec 200i - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC	getk

.getk
	call	$1e80
	ld	l,a
	ld	h,0
	ret
