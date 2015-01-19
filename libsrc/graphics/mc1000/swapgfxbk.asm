;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MC-1000, but we hang the interrupts, 
;		just in case they become critical.
;
;
;	$Id: swapgfxbk.asm,v 1.3 2015-01-19 01:32:49 pauloscustodio Exp $
;

		PUBLIC    swapgfxbk
		EXTERN	pixeladdress

		PUBLIC	swapgfxbk1

.swapgfxbk
		di
		ret

.swapgfxbk1
		ei
		ret
