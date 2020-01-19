;
;       Z88 Graphics Functions
;       Written around the Interlogic Standard Library
;
;       Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;

;
;	$Id: w_xordrawr_callee.asm $
;

; ----- void __CALLEE__ xordrawr_callee(int x, int y)


IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC xordrawr_callee
PUBLIC _xordrawr_callee
PUBLIC ASMDISP_XORDRAWR_CALLEE

	EXTERN     swapgfxbk
	;EXTERN    swapgfxbk1
	EXTERN     w_line_r
	EXTERN     w_xorpixel
	EXTERN     __graphics_end


.xordrawr_callee
._xordrawr_callee

   pop af
   pop de
   pop hl
   push af

.asmentry
		push ix
		call    swapgfxbk
        ld      ix,w_xorpixel
		call    w_line_r
		jp      __graphics_end


DEFC ASMDISP_XORDRAWR_CALLEE = asmentry - xordrawr_callee
ENDIF
