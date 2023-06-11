

SECTION code_fp_am9511

PUBLIC  cam32_sdcc___fsgt_callee

EXTERN asm_sdcc_readr_callee
EXTERN asm_am9511_compare_callee

; Entry: stack: float right, float left, ret
.cam32_sdcc___fsgt_callee
    call asm_sdcc_readr_callee      ;Exit dehl = right
    call asm_am9511_compare_callee
    jr Z,gt1
    ccf
    ret C
.gt1
    dec hl
    ret
