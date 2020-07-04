
SECTION code_fp_math16
PUBLIC cm16_sdcc_pow_callee

EXTERN powf16_callee


cm16_sdcc_pow_callee:
    pop hl      ; return
    pop de      ; RHS
    ex (sp),hl  ; return to stack, LHS
    
    push hl     ; LHS
    push de     ; RHS

    jp powf16_callee

