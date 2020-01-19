;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_unplot.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  unplot(int x, int y)


IF !__CPU_INTEL__
		SECTION   code_graphics
		
		PUBLIC    unplot
		PUBLIC	  _unplot
		
		EXTERN unplot_callee
		EXTERN ASMDISP_UNPLOT_CALLEE

.unplot
._unplot

   pop af
   pop de	; y
   pop hl	; x
   push hl
   push de
   push af

   jp unplot_callee + ASMDISP_UNPLOT_CALLEE
   
ENDIF
