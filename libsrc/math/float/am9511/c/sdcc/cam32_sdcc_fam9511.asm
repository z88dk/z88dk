
SECTION code_fp_am9511

PUBLIC cam32_sdcc_f32_fam9511
PUBLIC cam32_sdcc_fam9511_f32

EXTERN asm_sdcc_read1, asm_f32_am9511

.cam32_sdcc_f32_fam9511
    call asm_sdcc_read1
    jp asm_f32_am9511

EXTERN asm_sdcc_read1, asm_am9511_f32

.cam32_sdcc_fam9511_f32
    call asm_sdcc_read1
    jp asm_am9511_f32

