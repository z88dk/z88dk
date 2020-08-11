
SECTION code_fp_am9511
PUBLIC cam32_sdcc_pow_callee

EXTERN asm_am9511_pow_callee


.cam32_sdcc_pow_callee
    pop af      ; return
    pop bc      ; LHS LSB
    pop hl
    pop de      ; RHS
    ex (sp),hl  ; RHS MSB, LHS MSB to stack
    push bc     ; LHS LSB
    push af
    ex de,hl

    jp asm_am9511_pow_callee
