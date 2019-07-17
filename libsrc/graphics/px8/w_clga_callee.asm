
;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
;	$Id: w_clga_callee.asm $
;


;Usage: clga(struct *pixels)

 	SECTION code_graphics
	
	PUBLIC	clga_callee
	PUBLIC	_clga_callee
	
	PUBLIC	ASMDISP_CLGA_CALLEE

	EXTERN	w_area

	EXTERN	swapgfxbk
	EXTERN	__graphics_end

	
.clga_callee
._clga_callee

		pop af
		
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop de
		pop hl
		
		push af		; ret addr
		
		exx
		
.asmentry
		
		ld	a,1
		jp	w_area

DEFC ASMDISP_CLGA_CALLEE = # asmentry - clga_callee
