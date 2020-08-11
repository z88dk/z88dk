

SECTION code_fp_am9511
PUBLIC cam32_sccz80_sin

EXTERN cam32_sccz80_read1, _am9511_sin

.cam32_sccz80_sin
    call cam32_sccz80_read1
    jp _am9511_sin
