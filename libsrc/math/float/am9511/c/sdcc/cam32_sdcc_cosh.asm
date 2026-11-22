
SECTION code_fp_am9511

PUBLIC cam32_sdcc_cosh

EXTERN asm_sdcc_read1, _am9511_cosh

.cam32_sdcc_cosh
    call asm_sdcc_read1
    jp _am9511_cosh
