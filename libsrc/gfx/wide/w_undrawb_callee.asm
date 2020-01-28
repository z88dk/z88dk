;
; UnDrawbox
;
; Generic high resolution version
;

;
; $Id: w_undrawb_callee.asm $
;

IF !__CPU_INTEL__
 	SECTION code_graphics
	
	PUBLIC	undrawb_callee
	PUBLIC	_undrawb_callee
	
	PUBLIC	ASMDISP_UNDRAWB_CALLEE

	EXTERN	w_respixel
	EXTERN	drawbox

	EXTERN	swapgfxbk
	EXTERN	__graphics_end

	
.undrawb_callee
._undrawb_callee

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
		
		ld      ix,w_respixel
		call    drawbox

		jp      __graphics_end

DEFC ASMDISP_UNDRAWB_CALLEE = asmentry - undrawb_callee
ENDIF
