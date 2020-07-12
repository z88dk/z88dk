
SECTION code_fp_math16
PUBLIC cm16_sdcc_pow_callee

EXTERN asm_f16_pow


cm16_sdcc_pow_callee:
    pop de      ; return
    pop hl      ; LHS
    ex (sp),hl  ; LHS to stack, RHS
    push hl     ; RHS
    push de     ; return

    jp asm_f16_pow

