
SECTION code_fp_math32

PUBLIC cm32_sccz80_f32_fam9511
PUBLIC cm32_sccz80_fam9511_f32

EXTERN cm32_sccz80_fsread1, m32_f32_fam9511

.cm32_sccz80_f32_fam9511
    call cm32_sccz80_fsread1
    jp m32_f32_fam9511

EXTERN cm32_sccz80_fsread1, m32_fam9511_f32

.cm32_sccz80_fam9511_f32
    call cm32_sccz80_fsread1
    jp m32_fam9511_f32

