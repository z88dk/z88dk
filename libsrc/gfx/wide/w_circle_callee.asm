;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_circle_callee.asm $
;


IF !__CPU_INTEL__
; Usage: circle(int x, int y, int radius, int skip);


		SECTION         code_graphics
		
		PUBLIC    circle_callee
		PUBLIC    _circle_callee
		
		PUBLIC     ASMDISP_CIRCLE_CALLEE

		EXTERN     w_draw_circle
		EXTERN     w_plotpixel
		
		EXTERN     swapgfxbk
		EXTERN     __graphics_end

	
.circle_callee
._circle_callee

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
		push    af
                call    swapgfxbk
		pop     af
                ld      ix,w_plotpixel
                call    w_draw_circle
                jp      __graphics_end

DEFC ASMDISP_CIRCLE_CALLEE = asmentry - circle_callee
ENDIF
