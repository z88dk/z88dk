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


                XLIB    swapgfxbk

		XDEF	swapgfxbk1


.iysave		defw	0

.swapgfxbk
		ld	(iysave),iy
		ret
.swapgfxbk1
		ld	iy,(iysave)
                ret
