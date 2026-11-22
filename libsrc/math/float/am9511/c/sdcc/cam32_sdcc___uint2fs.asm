
SECTION code_fp_am9511
PUBLIC cam32_sdcc___uint2fs

EXTERN asm_am9511_float16u


.cam32_sdcc___uint2fs
    pop bc      ;return
    pop hl      ;value
    push hl
    push bc
    jp asm_am9511_float16u
