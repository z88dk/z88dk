;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: unplot.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  unplot(int x, int y)


		SECTION   code_graphics
		
		PUBLIC    unplot
		PUBLIC	  _unplot
		
		EXTERN unplot_callee
		EXTERN ASMDISP_UNPLOT_CALLEE

		
.unplot
._unplot
	pop	af	; ret addr
	pop hl	; y
	pop de	; x
	push de
	push hl
	ld	h,e
	push	af	; ret addr
		
   jp unplot_callee + ASMDISP_UNPLOT_CALLEE
