

SECTION code_fp_am9511
PUBLIC cam32_sccz80_mul10u

EXTERN cam32_sccz80_read1, asm_am9511_mul10u_fastcall

.cam32_sccz80_mul10u
    call cam32_sccz80_read1
    jp asm_am9511_mul10u_fastcall
