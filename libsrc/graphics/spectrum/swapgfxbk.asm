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
;	$Id: swapgfxbk.asm,v 1.2 2001-04-18 13:21:38 stefano Exp $
;

                XLIB    swapgfxbk

		XDEF	swapgfxbk1



.swapgfxbk
		di
		ret
.swapgfxbk1
		ld	iy,23610
		ei
                ret






