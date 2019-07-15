; CALLER linkage for function pointers

MODULE fputs
SECTION code_clib
PUBLIC fputs
EXTERN asm_fputs_callee

.fputs

	pop	hl	;ret
	pop	bc	;fp
	pop	de	;s
	push	de
	push	bc
	push	hl
IF __CPU_8080__
	call	asm_fputs_callee
ELSE
        push    ix  ; callers ix
        push    bc
        pop     ix
   	call	asm_fputs_callee
	pop	ix	
ENDIF
	ret

