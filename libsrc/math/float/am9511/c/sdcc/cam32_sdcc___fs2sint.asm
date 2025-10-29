
SECTION code_fp_am9511
PUBLIC cam32_sdcc___fs2sint
PUBLIC cam32_sdcc___fs2schar

EXTERN asm_am9511_f2sint
EXTERN asm_sdcc_read1

.cam32_sdcc___fs2sint
.cam32_sdcc___fs2schar
    call asm_sdcc_read1
    jp asm_am9511_f2sint
