; CALLER linkage for function pointers

PUBLIC fputc
PUBLIC _fputc
EXTERN _fputc_callee
EXTERN ASMDISP_FPUTC_CALLEE

.fputc
._fputc

	pop de
	pop	ix	;fp
	pop	bc	;c
	push	bc
	push	ix
	push de
   
   jp _fputc_callee + ASMDISP_FPUTC_CALLEE

