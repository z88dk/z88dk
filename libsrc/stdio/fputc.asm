; CALLER linkage for function pointers

MODULE fputc
SECTION code_clib
PUBLIC fputc
PUBLIC _fputc
EXTERN asm_fputc_callee

.fputc
._fputc
    pop     de      ;return address
    pop     hl      ;fp
    pop     bc      ;c
    push    bc
    push    hl
    push    de

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    push    ix        ;callers ix
    push    hl
    pop     ix
   	call    asm_fputc_callee 
    pop     ix
ELSE
	call	asm_fputc_callee
ENDIF
    ret
   


