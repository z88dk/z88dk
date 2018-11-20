
; ----- void __CALLEE__ cdrawr_callee(int x, int y, int c)

SECTION code_clib
PUBLIC cdrawr_callee
PUBLIC _cdrawr_callee
PUBLIC ASMDISP_CDRAWR_CALLEE

	EXTERN     swapgfxbk
	EXTERN    swapgfxbk1
	EXTERN    __gfx_color
	EXTERN     w_line_r
	EXTERN     w_cplotpixel
	EXTERN     __graphics_end


.cdrawr_callee
._cdrawr_callee

   pop af
   pop bc
   pop de
   pop hl
   push af

.asmentry
		ld	a,c
		ld	(__gfx_color),a
		push ix
		call    swapgfxbk	; DI and enter green page
        ld      ix,w_cplotpixel
		call    w_line_r
		jp      __graphics_end


DEFC ASMDISP_CDRAWR_CALLEE = # asmentry - cdrawr_callee
