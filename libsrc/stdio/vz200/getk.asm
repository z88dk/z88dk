;
;	Devilishly simple VZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: getk.asm,v 1.2 2001-04-13 14:14:00 stefano Exp $
;


		XLIB	getk

.getk
		call	12020		;scan keyboard once
		ld	l,a
		ld	h,0
		ret
