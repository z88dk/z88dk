
SECTION code_fp_am9511

PUBLIC cam32_sccz80_f32_fam9511
PUBLIC cam32_sccz80_fam9511_f32

EXTERN cam32_sccz80_read1, asm_f32_am9511

.cam32_sccz80_f32_fam9511
    call cam32_sccz80_read1
    jp asm_f32_am9511

EXTERN cam32_sccz80_read1, asm_am9511_f32

.cam32_sccz80_fam9511_f32
    call cam32_sccz80_read1
    jp asm_am9511_f32

