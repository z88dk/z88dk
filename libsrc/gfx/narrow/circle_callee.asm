;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: circle_callee.asm $
;


; Usage: circle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__ & !__CPU_GBZ80__
		SECTION         code_graphics
		
		PUBLIC    circle_callee
		PUBLIC    _circle_callee
		
		PUBLIC     ASMDISP_CIRCLE_CALLEE

		EXTERN     draw_circle
		EXTERN     plotpixel
		
		EXTERN     swapgfxbk
		EXTERN     __graphics_end

	
.circle_callee
._circle_callee
		pop		af
		
		pop		de	; skip
		pop		bc	;radius
		ld		d,c
		pop		bc	; y
		pop		hl	; x
		ld		b,l
		
		push	af

		push	ix
		
		
.asmentry
                ld      ix,plotpixel
                call    swapgfxbk
                call    draw_circle
                jp      __graphics_end

DEFC ASMDISP_CIRCLE_CALLEE = asmentry - circle_callee
ENDIF
