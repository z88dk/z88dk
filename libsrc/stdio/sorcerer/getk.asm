;
;	Keyboard routines for the Sorcerer Exidy
;	By Stefano Bodrato - 23/05/2011 (exactly 8 years after the Nascom ones !)
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2011-05-24 18:11:10 stefano Exp $
;

		XLIB	getk

.getk
	call $e009
	ld	l,a
	ld	h,0
	ret
