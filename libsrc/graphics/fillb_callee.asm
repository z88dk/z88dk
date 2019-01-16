;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;       Stubs Written by D Morris - 30/9/98
;
;	$Id: fillb_callee.asm $
;


;Usage: fillb(struct *pixels)


		SECTION         code_graphics
		
		PUBLIC    fillb_callee
		PUBLIC    _fillb_callee

		PUBLIC    ASMDISP_FILLB_CALLEE
		
		EXTERN     swapgfxbk
		EXTERN	  __graphics_end
		
		EXTERN     fillarea


.fillb_callee
._fillb_callee
		
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
		call    fillarea
		jp      __graphics_end


DEFC ASMDISP_FILLB_CALLEE = # asmentry - fillb_callee
