;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the Amstrad CPC.
;
;
;	$Id: swapgfxbk.asm,v 1.6 2016-06-19 21:10:08 dom Exp $
;
;	There might be something to put here; it looks like the
;	alternate registers and/or the index registers have to be
;	handled carefully
;

        SECTION   code_clib
                PUBLIC    swapgfxbk

		PUBLIC	swapgfxbk1

.swapgfxbk
		;di
		;ret

.swapgfxbk1
		;ei
                ret
