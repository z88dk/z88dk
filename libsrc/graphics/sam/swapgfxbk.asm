;
;       Z88 Graphics Functions - Small C+ stubs
;
;       SAM Coup version by Frode Tenneb 
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk.asm,v 1.2 2011-08-12 18:24:13 pauloscustodio Exp $
;
; registers changed after return:
;  ..bcdejl/..iy same
;  af....../ix.. different
; NB! Mad hack! I hope that iy is not used for anything else around. 
	
                XLIB    swapgfxbk

		XDEF	swapgfxbk1



.swapgfxbk
		di
		pop     iy
		ld      (swapsp1+1),sp
		ld      (accu+1),a
		in      a,(250)
	        ld      (swapgfxbk1+1),a
		ld      a,($5a78) ; in a,(252)
		and     @00011111
		dec	a
		out     (250),a
.accu		ld      a,0
		ld      sp,32768
		jp      (iy)

.swapgfxbk1
		ld	a,0
		out	(250),a
.swapsp1        ld      sp,0
		ei
		ret
