;
;	Philips P2000
;
;	getk() Read key status
;
;	Apr 2014 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.1 2014-04-17 06:16:05 stefano Exp $
;

	XLIB	getk

getk:
	ld	a,(24588)
	and a
	ret z

	call 1956h

	ld	l,a
	ld	h,0
	ret
