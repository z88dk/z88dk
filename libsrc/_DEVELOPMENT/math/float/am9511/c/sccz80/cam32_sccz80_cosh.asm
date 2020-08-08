

SECTION code_fp_am9511
PUBLIC cam32_sccz80_cosh

EXTERN cam32_sccz80_read1, _am9511_cosh

.cam32_sccz80_cosh
    call cam32_sccz80_read1
    jp _am9511_cosh
