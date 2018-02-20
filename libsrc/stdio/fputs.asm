; CALLER linkage for function pointers

MODULE fputs
SECTION code_clib
PUBLIC fputs
EXTERN asm_fputs_callee

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
   	call	asm_fputs_callee
	pop	ix	
	ret

