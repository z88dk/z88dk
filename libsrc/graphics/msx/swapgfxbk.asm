;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MSX.
;
;
;	$Id: swapgfxbk.asm,v 1.1 2007-12-18 09:00:44 stefano Exp $
;

                XLIB    swapgfxbk

		XDEF	swapgfxbk1

.swapgfxbk
		;di
		;ret

.swapgfxbk1
		;ei
                ret
