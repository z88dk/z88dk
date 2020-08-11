
SECTION code_fp_am9511
PUBLIC cam32_sdcc___sint2fs

EXTERN asm_am9511_float16


.cam32_sdcc___sint2fs
    pop bc      ;return
    pop hl      ;value
    push hl
    push bc
    jp asm_am9511_float16
