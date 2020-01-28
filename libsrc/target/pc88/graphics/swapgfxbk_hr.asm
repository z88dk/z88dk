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
;       Stefano - Sept 2018
;
;
;	$Id: swapgfxbk_hr.asm $
;

		SECTION code_clib
		PUBLIC    swapgfxbk
      PUBLIC    _swapgfxbk
		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1


.swapgfxbk
._swapgfxbk
		di
		out ($5e),a		; green	plane GVRAM page
		ret

.swapgfxbk1
._swapgfxbk1
		ei
		out ($5f),a		; back to standard RAM
		ret

