; CALLER linkage for function pointers

PUBLIC fputc
EXTERN fputc_callee
EXTERN ASMDISP_FPUTC_CALLEE

.fputc

	pop de
	pop	ix	;fp
	pop	bc	;c
	push	bc
	push	ix
	push de
   
   jp fputc_callee + ASMDISP_FPUTC_CALLEE

