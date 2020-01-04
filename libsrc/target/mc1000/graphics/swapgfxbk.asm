;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the MC-1000, but we hang the interrupts, 
;		just in case they become critical.
;
;
;	$Id: swapgfxbk.asm,v 1.5 2017-01-02 22:57:58 aralbrec Exp $
;


		SECTION	  code_clib
		PUBLIC    swapgfxbk
      PUBLIC    _swapgfxbk
		EXTERN	pixeladdress

		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1

.swapgfxbk
._swapgfxbk
		di
		ret

.swapgfxbk1
._swapgfxbk1
		ei
		ret
