;
; XorBorder
;
; Generic high resolution version
;

;
;	$Id: w_xorborder.asm $
;

IF !__CPU_INTEL__
SECTION code_graphics

PUBLIC xorborder
PUBLIC _xorborder

EXTERN xorborder_callee
EXTERN ASMDISP_XORBORDER_CALLEE

	
.xorborder
._xorborder

		pop af
		
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop de
		pop hl
		
		push hl
		push de
		exx
		push hl
		push de
		
		push af		; ret addr
		
   jp xorborder_callee + ASMDISP_XORBORDER_CALLEE
ENDIF
