
SECTION code_fp_math16

PUBLIC  cm16_sdcc___gt_callee

EXTERN cm16_sdcc_readr_callee
EXTERN asm_f16_compare_callee

; Entry: stack: half right, half left, ret
.cm16_sdcc___gt_callee
    call cm16_sdcc_readr_callee	    ;Exit hl = right
    call asm_f16_compare_callee
    jr Z,gt1
    ccf
    ret C
.gt1
    dec hl
    ret

