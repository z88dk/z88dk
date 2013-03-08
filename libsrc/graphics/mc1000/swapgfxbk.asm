;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MC-1000, but we hang the interrupts, 
;		just in case they become critical.
;
;
;	$Id: swapgfxbk.asm,v 1.2 2013-03-08 13:40:20 stefano Exp $
;

		XLIB    swapgfxbk
		LIB	pixeladdress

		XDEF	swapgfxbk1

.swapgfxbk
		di
		ret

.swapgfxbk1
		ei
		ret
