;
;	Sharp MZ Routines
;
;	getk() Read key status
;
;	Stefano Bodrato - 5/5/2000
;
;
;	$Id: getk.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;


		XLIB	getk

.getk
		call	$1B   ;get key
		cp	$66   ;was it ENTER ?
		jr	nz,noenter
		ld	a,13
.noenter
 		ld	l,a
		ld	h,0
		ret
