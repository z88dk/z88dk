;
;	ABC800 Routines
;
;	getk() Read key status
;
;	Oct 2007 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:17 pauloscustodio Exp $
;

	PUBLIC	getk

.getk
	call	2

	ld	l,a
	ld	h,0
	ret
