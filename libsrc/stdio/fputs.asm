; CALLER linkage for function pointers

XLIB fputs
LIB fputs_callee
XREF ASMDISP_FPUTS_CALLEE

.fputs

	pop	hl	;ret
	pop	ix	;fp
	pop	de	;s
	push	de
	push	ix
	push	hl
   
   jp fputs_callee + ASMDISP_FPUTS_CALLEE

