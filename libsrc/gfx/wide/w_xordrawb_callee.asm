;
; XorDrawbox
;
; Generic high resolution version
;

;
; $Id: w_xordrawb_callee.asm $
;

IF !__CPU_INTEL__
 	SECTION code_graphics
	
	PUBLIC	xordrawb_callee
	PUBLIC	_xordrawb_callee
	
	PUBLIC	ASMDISP_XORDRAWB_CALLEE

	EXTERN	w_xorpixel
	EXTERN	drawbox

	EXTERN	swapgfxbk
	EXTERN	__graphics_end

	
.xordrawb_callee
._xordrawb_callee

		pop af
		
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop de
		pop hl
		
		push af		; ret addr
		
		exx
		
.asmentry
		
		push	ix
		call    swapgfxbk
		
		ld      ix,w_xorpixel
		call    drawbox

		jp      __graphics_end

DEFC ASMDISP_XORDRAWB_CALLEE = asmentry - xordrawb_callee
ENDIF
