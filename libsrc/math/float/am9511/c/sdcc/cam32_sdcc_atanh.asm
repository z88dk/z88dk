
SECTION code_fp_am9511

PUBLIC cam32_sdcc_atanh

EXTERN asm_sdcc_read1, _am9511_atanh

.cam32_sdcc_atanh
    call asm_sdcc_read1
    jp _am9511_atanh
