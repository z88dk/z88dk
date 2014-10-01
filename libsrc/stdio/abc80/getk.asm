;
;	ABC80 Routines
;
;	getk() Read key status
;
;	Maj 2000 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.3 2014-10-01 20:27:22 stefano Exp $
;

	XLIB	getk

.getk
	in	a,(56)
	and 127
	ld	l,a
	ld	h,0
	ret
