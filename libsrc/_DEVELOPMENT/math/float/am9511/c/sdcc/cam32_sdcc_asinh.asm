
SECTION code_fp_am9511

PUBLIC cam32_sdcc_asinh

EXTERN asm_sdcc_read1, _am9511_asinh

.cam32_sdcc_asinh
    call asm_sdcc_read1
    jp _am9511_asinh
