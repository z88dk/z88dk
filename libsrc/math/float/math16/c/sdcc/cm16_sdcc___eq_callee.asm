
SECTION code_fp_math16

PUBLIC  cm16_sdcc___eq_callee

EXTERN cm16_sdcc_readr_callee
EXTERN asm_f16_compare_callee

; Entry: stack: half right, half left, ret
.cm16_sdcc___eq_callee
    call cm16_sdcc_readr_callee	    ;Exit hl = right
    call asm_f16_compare_callee
    scf
    ret Z
    ccf
    dec hl
    ret

