
SECTION code_fp_math16
PUBLIC cm16_sdcc_atan2_callee

EXTERN atan2f16_callee


cm16_sdcc_atan2_callee:
    pop de      ; return
    pop hl      ; LHS
    ex (sp),hl  ; LHS to stack, RHS
    push hl     ; RHS
    push de     ; return

    jp atan2f16_callee

