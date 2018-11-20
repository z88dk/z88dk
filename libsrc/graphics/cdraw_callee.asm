
; ----- void __CALLEE__ cdraw_callee(int x, int y, int x2, int y2, int c)

SECTION code_clib
PUBLIC cdraw_callee
PUBLIC _cdraw_callee
PUBLIC ASMDISP_CDRAW_CALLEE

	EXTERN     swapgfxbk
	EXTERN    swapgfxbk1
	EXTERN    __gfx_color
	EXTERN     w_line_r
	EXTERN     w_cplotpixel
	EXTERN     __graphics_end



.cdraw_callee
._cdraw_callee

.draw
._draw
		pop af
		pop bc	; color
		pop de
		pop	hl
		exx			; w_cplotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop hl
		pop de
		
		push af		; ret addr
		
		;push	ix
		
.asmentry
		
		exx
;		ld	l,(ix+6)
;		ld	h,(ix+7)
;		ld	e,(ix+4)
;		ld	d,(ix+5)
;		ld	c,(ix+8)
		
		push hl
		push de
		
		ld	a,c
		ld	(__gfx_color),a

		;push ix
		call    swapgfxbk
		call	w_cplotpixel
		call    swapgfxbk1
		;pop ix

		exx
		;ld	l,(ix+0)
		;ld	h,(ix+1)
		pop bc
		or a
		sbc hl,bc
		ex de,hl
		
		;ld	l,(ix+2)
		;ld	h,(ix+3)
		pop bc
		or a
		sbc hl,bc

		call    swapgfxbk
		push	ix
		ld      ix,w_cplotpixel
		call    w_line_r
		jp      __graphics_end




DEFC ASMDISP_CDRAW_CALLEE = # asmentry - cdraw_callee
