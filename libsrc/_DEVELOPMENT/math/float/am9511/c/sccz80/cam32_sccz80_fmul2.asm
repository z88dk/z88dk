

SECTION code_fp_am9511
PUBLIC cam32_sccz80_fmul2

EXTERN cam32_sccz80_read1, asm_am9511_fmul2_fastcall

.cam32_sccz80_fmul2
    call cam32_sccz80_read1
    jp asm_am9511_fmul2_fastcall
