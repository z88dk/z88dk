

SECTION code_fp_am9511
PUBLIC cam32_sccz80_asinh

EXTERN cam32_sccz80_read1, _am9511_asinh

.cam32_sccz80_asinh
    call cam32_sccz80_read1
    jp _am9511_asinh
