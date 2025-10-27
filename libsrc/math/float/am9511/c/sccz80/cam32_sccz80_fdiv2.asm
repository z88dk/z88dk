

SECTION code_fp_am9511
PUBLIC cam32_sccz80_fdiv2

EXTERN asm_sccz80_read1, asm_am9511_fdiv2_fastcall

.cam32_sccz80_fdiv2
    call asm_sccz80_read1
    jp asm_am9511_fdiv2_fastcall
