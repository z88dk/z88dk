
SECTION code_fp_am9511
PUBLIC cam32_sdcc___slong2fs_callee

EXTERN asm_am9511_float32


.cam32_sdcc___slong2fs_callee
    pop bc      ;return
    pop hl      ;value
    pop de
    push bc
    jp asm_am9511_float32
