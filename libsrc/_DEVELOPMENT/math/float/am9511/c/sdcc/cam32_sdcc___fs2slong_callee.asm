
SECTION code_fp_am9511
PUBLIC cam32_sdcc___fs2slong_callee

EXTERN asm_am9511_f2slong
EXTERN asm_sdcc_read1_callee

.cam32_sdcc___fs2slong_callee
    call asm_sdcc_read1_callee
    jp asm_am9511_f2slong
