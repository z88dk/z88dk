;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MSX.
;
;
;	$Id: swapgfxbk.asm,v 1.4 2009-05-21 06:58:11 stefano Exp $
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
