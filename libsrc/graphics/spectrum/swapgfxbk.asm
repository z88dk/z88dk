;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk.asm,v 1.3 2015-01-19 01:32:51 pauloscustodio Exp $
;

                PUBLIC    swapgfxbk

		PUBLIC	swapgfxbk1



.swapgfxbk
		di
		ret
.swapgfxbk1
		ld	iy,23610
		ei
                ret






