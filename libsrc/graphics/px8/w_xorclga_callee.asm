
;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;
;	$Id: w_xorclga_callee.asm $
;


;Usage: xorclga(struct *pixels)

 	SECTION code_graphics
	
	PUBLIC	xorclga_callee
	PUBLIC	_xorclga_callee
	
	PUBLIC	ASMDISP_XORCLGA_CALLEE

	EXTERN	w_area

	EXTERN	swapgfxbk
	EXTERN	__graphics_end

	
.xorclga_callee
._xorclga_callee

		pop af
		
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop de
		pop hl
		
		push af		; ret addr
		
		exx
		
.asmentry
		
		ld	a,3
		jp	w_area

DEFC ASMDISP_XORCLGA_CALLEE = # asmentry - xorclga_callee
