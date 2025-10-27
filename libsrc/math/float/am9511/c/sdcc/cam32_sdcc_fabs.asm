
SECTION code_fp_am9511

PUBLIC cam32_sdcc_fabs

EXTERN asm_sdcc_read1, asm_am9511_fabs_fastcall

.cam32_sdcc_fabs
    call asm_sdcc_read1
    jp asm_am9511_fabs_fastcall
