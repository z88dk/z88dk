;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the Amstrad CPC.
;
;
;	$Id: swapgfxbk.asm,v 1.4 2004-06-30 12:50:56 stefano Exp $
;
;	There might be something to put here; it looks like the
;	alternate registers and/or the index registers have to be
;	handled carefully
;

                XLIB    swapgfxbk

		XDEF	swapgfxbk1

.swapgfxbk
		;di
		;ret

.swapgfxbk1
		;ei
                ret
