
SECTION code_fp_math16
PUBLIC cm16_sdcc_atan2

EXTERN atan2f16_callee

.cm16_sdcc_atan2

    pop hl      ; return
    pop de      ; LHS
    ex (sp),hl  ; return to stack, RHS
    
    push de     ; LHS    
    push hl     ; RHS

    call atan2f16_callee
    pop bc
    push bc
    push bc
    push bc
    ret
