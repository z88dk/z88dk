;
;       Z88 Graphics Functions
;       Written around the Interlogic Standard Library
;
;       Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;
; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)
;
;
;	$Id: w_draw_callee.asm $
;

SECTION code_graphics
PUBLIC draw_callee
PUBLIC _draw_callee
PUBLIC ASMDISP_DRAW_CALLEE

	EXTERN     swapgfxbk
	EXTERN    swapgfxbk1
	;EXTERN    __gfx_color
	EXTERN     w_line_r
	EXTERN     w_plotpixel
	EXTERN     __graphics_end



.draw_callee
._draw_callee
		pop af
		;pop bc	; color
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop hl
		pop de
		
		push af		; ret addr
		
		exx
		
.asmentry
		
;		ld	l,(ix+6)
;		ld	h,(ix+7)
;		ld	e,(ix+4)
;		ld	d,(ix+5)
;		ld	c,(ix+8)
		
		
		;ld	a,c
		;ld	(__gfx_color),a

		push ix
		
		push hl
		push de
		
		call    swapgfxbk
		call	w_plotpixel
		;call    swapgfxbk1
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

		;call    swapgfxbk
		;push	ix
		ld      ix,w_plotpixel
		call    w_line_r
		jp      __graphics_end


DEFC ASMDISP_DRAW_CALLEE = asmentry - draw_callee
