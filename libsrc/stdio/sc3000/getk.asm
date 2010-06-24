;
;   SEGA SC-3000 C Library
;
;	getk() Read key status
;
;	$Id: getk.asm,v 1.1 2010-06-24 09:05:52 stefano Exp $
;

		XLIB	getk

.getk
	call	$42D4
	ld	l,a
	ld	h,0
	ret
