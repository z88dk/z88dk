; CALLER linkage for function pointers

MODULE fputs
SECTION code_clib
PUBLIC fputs
EXTERN fputs_callee
EXTERN ASMDISP_FPUTS_CALLEE

.fputs

	pop	bc	;ret
	pop	hl	;fp
	pop	de	;s
	push	de
	push	hl
	push	bc

        push    ix  ; callers ix
        push    hl
        pop     ix
   	call	fputs_callee + ASMDISP_FPUTS_CALLEE
	pop	ix	
	ret

