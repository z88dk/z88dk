;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: w_xorplot.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  xorplot(int x, int y)


IF !__CPU_INTEL__
		SECTION   code_graphics
		
		PUBLIC    xorplot
		PUBLIC	  _xorplot
		
		EXTERN xorplot_callee
		EXTERN ASMDISP_XORPLOT_CALLEE

.xorplot
._xorplot

   pop af
   pop de	; y
   pop hl	; x
   push hl
   push de
   push af

   jp xorplot_callee + ASMDISP_XORPLOT_CALLEE
   
ENDIF
