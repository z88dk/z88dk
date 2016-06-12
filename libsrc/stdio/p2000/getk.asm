;
;	Philips P2000
;
;	getk() Read key status
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.3 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

getk:
_getk:
	ld	a,(24588)
	and a
	ret z

	call 1956h

	ld	l,a
	ld	h,0
	ret
