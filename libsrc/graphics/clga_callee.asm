;
;       Z88 Graphics Functions - Small C+ stubs
;       Written around the Interlogic Standard Library
;       Stubs Written by D Morris - 30/9/98
;
;	$Id: clga_callee.asm $
;


;Usage: clga(struct *pixels)


		SECTION         code_graphics
		
		PUBLIC    clga_callee
		PUBLIC    _clga_callee

		PUBLIC    ASMDISP_CLGA_CALLEE
		
		EXTERN     swapgfxbk
		EXTERN	  __graphics_end
		
		EXTERN     cleararea


.clga_callee
._clga_callee
		
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
		call    cleararea
		jp      __graphics_end


DEFC ASMDISP_CLGA_CALLEE = # asmentry - clga_callee
