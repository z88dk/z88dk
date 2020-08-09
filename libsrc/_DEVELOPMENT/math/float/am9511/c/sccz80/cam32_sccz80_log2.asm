

SECTION code_fp_am9511
PUBLIC cm32_sccz80_log2

EXTERN cam32_sccz80_read1, _am9511_log2

.cm32_sccz80_log2
    call cam32_sccz80_read1
    jp _am9511_log2
