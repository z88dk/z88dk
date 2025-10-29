
SECTION code_fp_math16
PUBLIC cm16_sccz80_pow

EXTERN asm_f16_pow

.cm16_sccz80_pow

    pop hl      ; return
    pop de      ; RHS
    ex (sp),hl  ; return to stack, LHS

    push hl     ; LHS
    push de     ; RHS

    call asm_f16_pow
    pop bc
    push bc
    push bc
    push bc
    ret
