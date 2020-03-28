;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
; ----- void __CALLEE__ xordraw(int x, int y, int x2, int y2)
;
;	$Id: xordraw_callee.asm $
;

	SECTION   code_graphics

	PUBLIC    xordraw_callee
	PUBLIC    _xordraw_callee
	
	PUBLIC    ASMDISP_XORDRAW_CALLEE

	EXTERN    swapgfxbk
	EXTERN    __graphics_end
	
	EXTERN    Line
	EXTERN    xorpixel


.xordraw_callee
._xordraw_callee	
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
	call	xorpixel
	pop     de
	pop	hl
		ld      ix,xorpixel
		call    Line
	jp	__graphics_end


DEFC ASMDISP_XORDRAW_CALLEE = asmentry - xordraw_callee
