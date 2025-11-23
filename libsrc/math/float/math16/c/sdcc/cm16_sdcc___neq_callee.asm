
SECTION code_fp_math16

PUBLIC  cm16_sdcc___neq_callee

EXTERN cm16_sdcc_readr_callee
EXTERN asm_f16_compare_callee

; Entry: stack: half right, half left, ret
.cm16_sdcc___neq_callee
    call cm16_sdcc_readr_callee	    ;Exit hl = right
    call asm_f16_compare_callee
    scf
    ret NZ
    ccf
    dec hl
    ret

