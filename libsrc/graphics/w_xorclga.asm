;
; XORCLGA  -  invert rect area
;
; Generic high resolution version
;

;
;	$Id: w_xorclga.asm $
;

SECTION code_graphics
PUBLIC xorclga
PUBLIC _xorclga
EXTERN xorclga_callee
EXTERN ASMDISP_XORCLGA_CALLEE

	
.xorclga
._xorclga

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
		
   jp xorclga_callee + ASMDISP_XORCLGA_CALLEE
