
SECTION code_fp_am9511
PUBLIC cam32_sdcc___uchar2fs_callee

EXTERN asm_am9511_float8u


.cam32_sdcc___uchar2fs_callee
    pop bc      ;return
    pop hl      ;value
    dec sp
    push bc
    jp asm_am9511_float8u
