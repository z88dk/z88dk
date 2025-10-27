
SECTION code_fp_am9511
PUBLIC cam32_sdcc___uchar2fs_callee

EXTERN asm_am9511_float8u


.cam32_sdcc___uchar2fs_callee
    pop bc      ;return
    dec sp
    pop hl      ;value
    push bc
    ld l,h
    jp asm_am9511_float8u
