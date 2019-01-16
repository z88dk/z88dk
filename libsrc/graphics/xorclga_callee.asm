;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;       Stubs Written by D Morris - 30/9/98
;
;	$Id: xorclga_callee.asm $
;


;Usage: xorclga(struct *pixels)


		SECTION         code_graphics
		
		PUBLIC    xorclga_callee
		PUBLIC    _xorclga_callee

		PUBLIC    ASMDISP_XORCLGA_CALLEE
		
		EXTERN     swapgfxbk
		EXTERN	  __graphics_end
		
		EXTERN     xorclrarea


.xorclga_callee
._xorclga_callee
		
	pop	af	; ret addr
	pop bc	; y2
	pop hl
	ld	b,l	; x2
	pop hl	; y
	pop de
	ld	h,e	; x
	push	af	; ret addr
		
.asmentry
		push	ix
		call    swapgfxbk
		call    xorclrarea
		jp      __graphics_end


DEFC ASMDISP_XORCLGA_CALLEE = # asmentry - xorclga_callee
