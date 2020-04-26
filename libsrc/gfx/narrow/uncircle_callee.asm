;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: uncircle_callee.asm $
;


; Usage: uncircle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__ & !__CPU_GBZ80__
		SECTION         code_graphics
		
		PUBLIC    uncircle_callee
		PUBLIC    _uncircle_callee
		
		PUBLIC     ASMDISP_UNCIRCLE_CALLEE

		EXTERN     draw_circle
		EXTERN     respixel
		
		EXTERN     swapgfxbk
		EXTERN     __graphics_end

	
.uncircle_callee
._uncircle_callee
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
		push	af
                call    swapgfxbk
		pop	af
                ld      ix,respixel
                call    draw_circle
                jp      __graphics_end

DEFC ASMDISP_UNCIRCLE_CALLEE = asmentry - uncircle_callee
ENDIF
