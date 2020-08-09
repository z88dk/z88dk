
SECTION code_fp_am9511
PUBLIC cam32_sdcc___fs2uint
PUBLIC cam32_sdcc___fs2uchar

EXTERN asm_am9511_f2uint
EXTERN cam32_sdcc_read1

.cam32_sdcc___fs2uint
.cam32_sdcc___fs2uchar
    call cam32_sdcc_read1
    jp asm_am9511_f2uint
