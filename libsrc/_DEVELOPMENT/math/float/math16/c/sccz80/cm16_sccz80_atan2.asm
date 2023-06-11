
SECTION code_fp_math16
PUBLIC cm16_sccz80_atan2

EXTERN atan2f16_callee

.cm16_sccz80_atan2

    pop hl      ; return
    pop de      ; RHS
    ex (sp),hl  ; return to stack, LHS

    push hl     ; LHS
    push de     ; RHS

    call atan2f16_callee
    pop bc
    push bc
    push bc
    push bc
    ret
