;
;	Philips P2000
;
;	getk() Read key status
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;

	PUBLIC	getk

getk:
	ld	a,(24588)
	and a
	ret z

	call 1956h

	ld	l,a
	ld	h,0
	ret
