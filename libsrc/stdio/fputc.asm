; CALLER linkage for function pointers

XLIB fputc
LIB fputc_callee
XREF ASMDISP_FPUTC_CALLEE

.fputc

	pop de
	pop	ix	;fp
	pop	bc	;c
	push	bc
	push	ix
	push de
   
   jp fputc_callee + ASMDISP_FPUTC_CALLEE

