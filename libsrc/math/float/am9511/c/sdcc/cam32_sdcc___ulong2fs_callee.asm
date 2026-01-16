
SECTION code_fp_am9511
PUBLIC cam32_sdcc___ulong2fs_callee

EXTERN asm_am9511_float32u


.cam32_sdcc___ulong2fs_callee
    pop bc      ;return
    pop hl      ;value
    pop de
    push bc
    jp asm_am9511_float32u
