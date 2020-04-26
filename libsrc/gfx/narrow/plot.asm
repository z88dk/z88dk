;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: plot.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  plot(int x, int y)


		SECTION   code_graphics
		
		PUBLIC    plot
		PUBLIC	  _plot
		
		EXTERN plot_callee
		EXTERN ASMDISP_PLOT_CALLEE

		
.plot
._plot
	pop	af	; ret addr
	pop hl	; y
	pop de	; x
	push de
	push hl
	ld	h,e
	push	af	; ret addr
		
   jp plot_callee + ASMDISP_PLOT_CALLEE
ENDIF
