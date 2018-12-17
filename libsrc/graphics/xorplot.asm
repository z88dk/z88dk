;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: xorplot.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xorplot(int x, int y)


		SECTION   code_graphics
		
		PUBLIC    xorplot
		PUBLIC	  _xorplot
		
		EXTERN xorplot_callee
		EXTERN ASMDISP_XORPLOT_CALLEE

		
.xorplot
._xorplot
	pop	af	; ret addr
	pop hl	; y
	pop de	; x
	push de
	push hl
	ld	h,e
	push	af	; ret addr
		
   jp xorplot_callee + ASMDISP_XORPLOT_CALLEE
