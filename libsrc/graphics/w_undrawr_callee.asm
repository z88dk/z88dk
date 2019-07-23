;
;       Z88 Graphics Functions
;       Written around the Interlogic Standard Library
;
;       Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;

;
;	$Id: w_undrawr_callee.asm $
;

; ----- void __CALLEE__ undrawr_callee(int x, int y)


SECTION code_graphics
PUBLIC undrawr_callee
PUBLIC _undrawr_callee
PUBLIC ASMDISP_UNDRAWR_CALLEE

	EXTERN     swapgfxbk
	;EXTERN    swapgfxbk1
	EXTERN     w_line_r
	EXTERN     w_respixel
	EXTERN     __graphics_end


.undrawr_callee
._undrawr_callee

   pop af
   pop de
   pop hl
   push af

.asmentry
		push ix
		call    swapgfxbk
        ld      ix,w_respixel
		call    w_line_r
		jp      __graphics_end


DEFC ASMDISP_UNDRAWR_CALLEE = asmentry - undrawr_callee
