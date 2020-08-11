
SECTION code_fp_am9511
PUBLIC cam32_sdcc___schar2fs

EXTERN asm_am9511_float8


.cam32_sdcc___schar2fs
    pop bc      ;return
    pop hl      ;value
    push hl
    push bc
    jp asm_am9511_float8
