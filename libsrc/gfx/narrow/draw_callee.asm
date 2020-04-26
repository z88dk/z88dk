;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)
;
;	$Id: draw_callee.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
	SECTION   code_graphics

	PUBLIC    draw_callee
	PUBLIC    _draw_callee
	
	PUBLIC    ASMDISP_DRAW_CALLEE

	EXTERN    swapgfxbk
	EXTERN    __graphics_end
	
	EXTERN    Line
	EXTERN    plotpixel


.draw_callee
._draw_callee	
	pop	af	; ret addr
	pop de	; y2
	pop hl
	ld	d,l	; x2
	pop hl	; y
	pop bc
	ld	h,c	; x
	push	af	; ret addr
	
.asmentry
	push	ix
	call    swapgfxbk
	push	hl
	push    de
	call	plotpixel
	pop     de
	pop	hl
		ld      ix,plotpixel
		call    Line
	jp	__graphics_end


DEFC ASMDISP_DRAW_CALLEE = asmentry - draw_callee
ENDIF
