
SECTION code_fp_math16
PUBLIC cm16_sdcc_pow_callee

EXTERN powf16_callee


cm16_sdcc_pow_callee:
    pop de      ; return
    pop hl      ; LHS
    ex (sp),hl  ; LHS to stack, RHS
    push hl     ; RHS
    push de     ; return

    jp powf16_callee

