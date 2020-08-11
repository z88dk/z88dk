

SECTION code_fp_am9511
PUBLIC cam32_sccz80_sinh

EXTERN cam32_sccz80_read1, _am9511_sinh

cam32_sccz80_sinh:
    call cam32_sccz80_read1
    jp _am9511_sinh
