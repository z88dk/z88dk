
;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
;	$Id: w_fillb_callee.asm $
;


;Usage: fillb(struct *pixels)

 	SECTION code_graphics
	
	PUBLIC	fillb_callee
	PUBLIC	_fillb_callee
	
	PUBLIC	ASMDISP_FILLB_CALLEE

	EXTERN	w_area

	EXTERN	swapgfxbk
	EXTERN	__graphics_end

	
.fillb_callee
._fillb_callee

		pop af
		
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop de
		pop hl
		
		push af		; ret addr
		
		exx
		
.asmentry
		
		ld	a,2
		jp	w_area

DEFC ASMDISP_FILLB_CALLEE = # asmentry - fillb_callee
