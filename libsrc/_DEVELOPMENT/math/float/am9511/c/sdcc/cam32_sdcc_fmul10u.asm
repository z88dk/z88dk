
SECTION code_fp_am9511

PUBLIC cam32_sdcc_fmul10u

EXTERN asm_sdcc_read1, asm_am9511_fmul10u_fastcall

.cam32_sdcc_fmul10u
    call asm_sdcc_read1
    jp asm_am9511_fmul10u_fastcall
