

SECTION code_fp_am9511
PUBLIC cam32_sccz80_fabs

EXTERN cam32_sccz80_read1, asm_am9511_fabs_fastcall

.cam32_sccz80_fabs
    call cam32_sccz80_read1
    jp asm_am9511_fabs_fastcall
