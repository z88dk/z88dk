;
;       Page the graphics bank in/out - used by all gfx functions
;       Doesn't really page on the Amstrad CPC.
;
;
;	$Id: swapgfxbk.asm,v 1.7 2017-01-02 22:57:57 aralbrec Exp $
;
;	There might be something to put here; it looks like the
;	alternate registers and/or the index registers have to be
;	handled carefully
;

        SECTION   code_clib
                PUBLIC    swapgfxbk
                PUBLIC    _swapgfxbk

		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1

.swapgfxbk
._swapgfxbk
		;di
		;ret

.swapgfxbk1
._swapgfxbk1
		;ei
                ret
