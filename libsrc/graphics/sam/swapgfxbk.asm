;
;       Z88 Graphics Functions - Small C+ stubs
;
;       SAM Coup version by Frode Tenneb 
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk.asm,v 1.4 2016-06-20 21:47:41 dom Exp $
;
; registers changed after return:
;  ..bcdejl/..iy same
;  af....../ix.. different
; NB! Mad hack! I hope that iy is not used for anything else around. 


		SECTION	  code_clib	
                PUBLIC    swapgfxbk

		PUBLIC	swapgfxbk1



.swapgfxbk
		di
		pop     iy
		ld      (swapsp),sp
		ld      (savea),a
		in      a,(250)
	        ld      (swapgfxbk1+1),a
		ld      a,($5a78) ; in a,(252)
		and     @00011111
		dec	a
		out     (250),a
		ld	a,(savea)
		ld      sp,32768
		jp      (iy)

.swapgfxbk1
		ld	a,0
		out	(250),a
		ld	sp,(swapsp)
		ei
		ret

	SECTION		bss_clib
swapsp:	defw	0
savea:	defb	0
