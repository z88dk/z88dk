;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the Amstrad CPC.
;
;
;	$Id: swapgfxbk.asm,v 1.5 2015-01-19 01:32:47 pauloscustodio Exp $
;
;	There might be something to put here; it looks like the
;	alternate registers and/or the index registers have to be
;	handled carefully
;

                PUBLIC    swapgfxbk

		PUBLIC	swapgfxbk1

.swapgfxbk
		;di
		;ret

.swapgfxbk1
		;ei
                ret
