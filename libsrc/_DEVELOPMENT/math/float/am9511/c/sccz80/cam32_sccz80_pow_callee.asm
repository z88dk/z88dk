
SECTION code_fp_am9511
PUBLIC cam32_sccz80_pow_callee

EXTERN asm_am9511_pow


.cam32_sccz80_pow_callee
    pop hl      ; return
    pop bc      ; RHS
    pop de
    pop af      ; LHS
    ex (sp),hl  ; return to stack

    push de     ; RHS
    push bc
    push hl     ; LHS
    push af

    call asm_am9511_pow
    pop af
    pop af
    pop af
    pop af
    ret
