

SECTION code_fp_am9511
PUBLIC cam32_sccz80_fdiv2

EXTERN cam32_sccz80_read1, asm_am9511_fdiv2_fastcall

.cam32_sccz80_fdiv2
    call cam32_sccz80_read1
    jp asm_am9511_fdiv2_fastcall
