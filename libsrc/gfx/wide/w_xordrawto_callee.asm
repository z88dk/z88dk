;
;       Z88 Graphics Functions
;       Written around the Interlogic Standard Library
;
;       Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;

;
;	$Id: w_xordrawto_callee.asm $
;

; ----- void __CALLEE__ xordrawto_callee(int x, int y)


IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC xordrawto_callee
PUBLIC _xordrawto_callee
PUBLIC ASMDISP_XORDRAWTO_CALLEE

	EXTERN     swapgfxbk
	;EXTERN    swapgfxbk1
	EXTERN     w_line
	EXTERN     w_xorpixel
	EXTERN     __graphics_end


.xordrawto_callee
._xordrawto_callee

   pop af
   pop de
   pop hl
   push af

.asmentry
		push ix
		call    swapgfxbk
        ld      ix,w_xorpixel
		call    w_line
		jp      __graphics_end


DEFC ASMDISP_XORDRAWTO_CALLEE = asmentry - xordrawto_callee
ENDIF
