
SECTION code_fp_am9511

PUBLIC cam32_sdcc_round

EXTERN asm_sdcc_read1, _am9511_round

.cam32_sdcc_round
    call asm_sdcc_read1
    jp _am9511_round
