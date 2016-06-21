;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MSX.
;
;
;	$Id: swapgfxbk.asm,v 1.6 2016-06-21 20:16:35 dom Exp $
;

		SECTION   code_clib
                PUBLIC    swapgfxbk
		EXTERN	pixeladdress

		PUBLIC	swapgfxbk1

.swapgfxbk
		di
		ret

.swapgfxbk1
		ei
                ret
