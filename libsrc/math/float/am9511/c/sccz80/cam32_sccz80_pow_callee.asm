
SECTION code_fp_am9511
PUBLIC cam32_sccz80_pow_callee

EXTERN asm_am9511_pow_callee


.cam32_sccz80_pow_callee
    pop hl      ; return
    pop de      ; RHS LSB
    ex (sp),hl  ; RHS MSB, return to stack
    ex de,hl

    jp asm_am9511_pow_callee
