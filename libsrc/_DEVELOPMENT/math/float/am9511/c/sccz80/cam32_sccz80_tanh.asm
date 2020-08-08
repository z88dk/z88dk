

SECTION code_fp_am9511
PUBLIC cam32_sccz80_tanh

EXTERN cam32_sccz80_read1, _am9511_tanh

.cam32_sccz80_tanh
    call cam32_sccz80_read1
    jp _am9511_tanh
