;
;	Mattel AQUARIUS Routines
;
;	getk() Read key status
;
;	Dec 200i - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.1 2001-12-24 13:23:08 stefano Exp $
;

	XLIB	getk

.getk
	call	$1e80
	ld	l,a
	ld	h,0
	ret
