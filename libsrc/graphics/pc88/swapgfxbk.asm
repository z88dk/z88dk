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
;	$Id: swapgfxbk.asm $
;

		SECTION code_clib
		PUBLIC    swapgfxbk
      PUBLIC    _swapgfxbk
		PUBLIC	swapgfxbk1
      PUBLIC   _swapgfxbk1


.swapgfxbk
._swapgfxbk
		;call kjt_wait_vrt		; wait for last line of display
		;call kjt_page_in_video	; page video RAM in at $2000-$3fff
		
		di
		ld	a,255
		out ($5e),a		; green	plane GVRAM page
		ret

.swapgfxbk1
._swapgfxbk1
        ei
		out ($5f),a		; back to standard RAM
		ret
