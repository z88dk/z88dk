

SECTION code_fp_am9511
PUBLIC cam32_sccz80_round

EXTERN cam32_sccz80_read1, _am9511_round

.cam32_sccz80_round
    call cam32_sccz80_read1
    jp _am9511_round
