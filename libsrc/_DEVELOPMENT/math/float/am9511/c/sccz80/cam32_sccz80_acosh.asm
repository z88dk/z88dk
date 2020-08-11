

SECTION code_fp_am9511
PUBLIC cam32_sccz80_acosh

EXTERN cam32_sccz80_read1, _am9511_acosh

.cam32_sccz80_acosh
    call cam32_sccz80_read1
    jp _am9511_acosh
