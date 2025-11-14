
SECTION code_fp_am9511
PUBLIC cam32_sdcc___fs2uint_callee
PUBLIC cam32_sdcc___fs2uchar_callee

EXTERN asm_am9511_f2uint
EXTERN asm_sdcc_read1_callee

.cam32_sdcc___fs2uint_callee
.cam32_sdcc___fs2uchar_callee
    call asm_sdcc_read1_callee
    jp asm_am9511_f2uint
