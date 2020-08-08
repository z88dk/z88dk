

SECTION code_fp_am9511
PUBLIC cam32_sccz80_atanh

EXTERN cam32_sccz80_read1, _am9511_atanh

.cam32_sccz80_atanh
    call cam32_sccz80_read1
    jp _am9511_atanh
