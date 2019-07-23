;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_xorcircle_callee.asm $
;


; Usage: xorcircle(int x, int y, int radius, int skip);


		SECTION         code_graphics
		
		PUBLIC    xorcircle_callee
		PUBLIC    _xorcircle_callee
		
		PUBLIC     ASMDISP_XORCIRCLE_CALLEE

		EXTERN     w_draw_circle
		EXTERN     w_xorpixel
		
		EXTERN     swapgfxbk
		EXTERN     __graphics_end

	
.xorcircle_callee
._xorcircle_callee

;       de = x0, hl = y0, bc = radius, a = skip

		pop		af
		ex		af,af
		
		pop		de	; skip
		ld		a,e
		pop		bc	;radius
		pop		hl	; y
		pop		de	; x
		
		ex		af,af
		push	af
		ex		af,af

		push	ix
		
		
.asmentry
		push	af
                call    swapgfxbk
		pop	af
                ld      ix,w_xorpixel
                call    w_draw_circle
                jp      __graphics_end

DEFC ASMDISP_XORCIRCLE_CALLEE = asmentry - xorcircle_callee
