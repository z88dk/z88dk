;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MSX.
;
;
;	$Id: swapgfxbk.asm,v 1.2 2009-01-21 16:00:08 stefano Exp $
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
