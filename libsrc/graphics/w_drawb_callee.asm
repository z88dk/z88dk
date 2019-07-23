;
; Drawbox
;
; Generic high resolution version
;

;
; $Id: w_drawb_callee.asm $
;

 	SECTION code_graphics
	
	PUBLIC	drawb_callee
	PUBLIC	_drawb_callee
	
	PUBLIC	ASMDISP_DRAWB_CALLEE

	EXTERN	w_plotpixel
	EXTERN	drawbox

	EXTERN	swapgfxbk
	EXTERN	__graphics_end

	
.drawb_callee
._drawb_callee

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
		
		ld      ix,w_plotpixel
		call    drawbox

		jp      __graphics_end

DEFC ASMDISP_DRAWB_CALLEE = asmentry - drawb_callee
