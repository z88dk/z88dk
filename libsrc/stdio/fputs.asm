; CALLER linkage for function pointers

MODULE fputs
SECTION code_clib
PUBLIC fputs
PUBLIC _fputs
EXTERN asm_fputs_callee

.fputs
._fputs
    pop     hl	;ret
    pop     bc	;fp
    pop     de	;s
    push    de
    push    bc
    push    hl
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    asm_fputs_callee
  IF __CPU_GBZ80__
    ld      d,h
    ld      e,l
  ENDIF
ELSE
    push    ix  ; callers ix
    push    bc
    pop     ix
    call    asm_fputs_callee
    pop     ix
ENDIF
    ret

