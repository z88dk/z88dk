

SECTION code_fp_math32
PUBLIC cam32_sccz80_exp10

EXTERN cam32_sccz80_read1, _am9511_exp10

.cam32_sccz80_exp10
    call cam32_sccz80_read1
    jp _am9511_exp10
