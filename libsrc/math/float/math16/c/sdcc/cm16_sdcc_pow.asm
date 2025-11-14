
SECTION code_fp_math16
PUBLIC cm16_sdcc_pow

EXTERN asm_f16_pow

.cm16_sdcc_pow

    pop hl      ; return
    pop de      ; LHS
    ex (sp),hl  ; return to stack, RHS
    
    push de     ; LHS    
    push hl     ; RHS

    call asm_f16_pow
    pop bc
    push bc
    push bc
    push bc
    ret
