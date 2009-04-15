;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MSX.
;
;
;	$Id: swapgfxbk.asm,v 1.3 2009-04-15 21:00:58 stefano Exp $
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
