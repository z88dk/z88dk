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
;       Stefano - Sept 2011
;
;
;	$Id: swapgfxbk.asm,v 1.1 2011-09-02 12:43:57 stefano Exp $
;

    INCLUDE "flos.def"

		XLIB    swapgfxbk

		XDEF	swapgfxbk1



.swapgfxbk
		call kjt_wait_vrt		; wait for last line of display
		call kjt_page_in_video	; page video RAM in at $2000-$3fff
		di
		ret

.swapgfxbk1
		call kjt_page_out_video	; page video RAM out of $2000-$3fff
		ei
		ret






