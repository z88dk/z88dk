
SECTION code_fp_am9511
PUBLIC cam32_sdcc___ulong2fs

EXTERN asm_am9511_float32u


.cam32_sdcc___ulong2fs
    pop bc      ;return
    pop hl      ;value
    pop de
    push de
    push hl
    push bc
    jp asm_am9511_float32u
