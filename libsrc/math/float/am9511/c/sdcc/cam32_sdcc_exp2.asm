
SECTION code_fp_am9511

PUBLIC cam32_sdcc_exp2

EXTERN asm_sdcc_read1, _am9511_exp2

.cam32_sdcc_exp2
    call asm_sdcc_read1
    jp _am9511_exp2
