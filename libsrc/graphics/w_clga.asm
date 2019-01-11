;
; CLGA  -  clear rect area
;
; Generic high resolution version
;

;
;	$Id: w_clga.asm $
;

SECTION code_graphics
PUBLIC clga
PUBLIC _clga
EXTERN clga_callee
EXTERN ASMDISP_CLGA_CALLEE

	
.clga
._clga

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
		
   jp clga_callee + ASMDISP_CLGA_CALLEE
