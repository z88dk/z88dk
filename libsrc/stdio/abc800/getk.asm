;
;	ABC800 Routines
;
;	getk() Read key status
;
;	Oct 2007 - Stefano Bodrato
;
;
;	$Id: getk.asm,v 1.1 2007-11-08 14:11:51 stefano Exp $
;

	XLIB	getk

.getk
	call	2

	ld	l,a
	ld	h,0
	ret
