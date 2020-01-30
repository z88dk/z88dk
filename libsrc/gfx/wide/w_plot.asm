;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_plot.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  plot(int x, int y)


		SECTION   code_graphics
		
		PUBLIC    plot
		PUBLIC	  _plot
		
		EXTERN plot_callee
		EXTERN ASMDISP_PLOT_CALLEE

.plot
._plot

   pop af
   pop de	; y
   pop hl	; x
   push hl
   push de
   push af

   jp plot_callee + ASMDISP_PLOT_CALLEE
   
