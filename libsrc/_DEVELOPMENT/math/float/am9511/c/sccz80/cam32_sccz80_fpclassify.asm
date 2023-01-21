

SECTION code_fp_am9511
PUBLIC cam32_sccz80_fpclassify

EXTERN asm_sccz80_read1, asm_am9511_fpclassify

.cam32_sccz80_fpclassify
    call asm_sccz80_read1
    call asm_am9511_fpclassify
    ld l,a
    ld h,0
    ret
