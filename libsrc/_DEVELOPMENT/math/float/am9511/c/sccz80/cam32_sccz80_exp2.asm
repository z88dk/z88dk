

SECTION code_fp_am9511
PUBLIC cam32_sccz80_exp2

EXTERN cam32_sccz80_read1, _am9511_exp2

.cam32_sccz80_exp2
    call cam32_sccz80_read1
    jp _am9511_exp2
