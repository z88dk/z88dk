
; ----- void __CALLEE__ cplot_callee(int x, int y, int c)

SECTION code_clib
PUBLIC cplot_callee
PUBLIC _cplot_callee
PUBLIC ASMDISP_CPLOT_CALLEE

	EXTERN     swapgfxbk
	EXTERN    swapgfxbk1
	EXTERN    __gfx_color
	EXTERN     w_cplotpixel


.cplot_callee
._cplot_callee

   pop af
   pop bc
   pop de
   pop hl
   push af

.asmentry
		ld	a,c
		ld	(__gfx_color),a
		call    swapgfxbk	; green page
		
		call	w_cplotpixel

		jp      swapgfxbk1

DEFC ASMDISP_CPLOT_CALLEE = asmentry - cplot_callee

