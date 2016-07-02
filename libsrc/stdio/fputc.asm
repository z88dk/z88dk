; CALLER linkage for function pointers

MODULE fputc
SECTION code_clib
PUBLIC fputc
PUBLIC _fputc
EXTERN _fputc_callee
EXTERN ASMDISP_FPUTC_CALLEE

.fputc
._fputc
        pop     de      ;return address
        pop     hl      ;fp
        pop     bc      ;c
        push    bc
        push    hl
        push    de

        push    ix        ;callers ix
        push    hl
        pop     ix
   	call    _fputc_callee + ASMDISP_FPUTC_CALLEE
        pop     ix
        ret
   


