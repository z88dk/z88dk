;
;	Keyboard routines for the Canon X-07
;	By Stefano Bodrato - 10/6/2011
;
;	getk() Read key status
;
;
;	$Id: getk.asm,v 1.1 2011-06-15 20:15:00 stefano Exp $
;

		XLIB	getk

.getk
	xor	a
	jp $C90A
