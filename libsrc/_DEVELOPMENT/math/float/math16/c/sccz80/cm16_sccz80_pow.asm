
SECTION code_fp_math16
PUBLIC cm16_sccz80_pow

EXTERN powf16_callee

.cm16_sccz80_pow

    pop hl      ; return
    pop de      ; LHS
    ex (sp),hl  ; return to stack, RHS
    
    push hl     ; RHS
    push de     ; LHS

    call powf16_callee
    pop bc
    push bc
    push bc
    push bc
    ret
