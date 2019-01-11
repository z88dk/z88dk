;
; FILLB  -  draw a filled rect area
;
; Generic high resolution version
;

;
;	$Id: w_fillb.asm $
;

SECTION code_graphics
PUBLIC fillb
PUBLIC _fillb
EXTERN fillb_callee
EXTERN ASMDISP_FILLB_CALLEE

	
.fillb
._fillb

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
		
   jp fillb_callee + ASMDISP_FILLB_CALLEE
