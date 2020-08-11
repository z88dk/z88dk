

SECTION code_fp_am9511
PUBLIC cam32_sccz80_mul2

EXTERN cam32_sccz80_read1, asm_am9511_mul2_fastcall

.cam32_sccz80_mul2
    call cam32_sccz80_read1
    jp asm_am9511_mul2_fastcall
