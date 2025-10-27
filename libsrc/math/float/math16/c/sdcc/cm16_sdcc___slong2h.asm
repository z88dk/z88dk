
SECTION code_fp_math16

PUBLIC cm16_sdcc___slong2h

EXTERN asm_f24_i32
EXTERN asm_f16_f24

.cm16_sdcc___slong2h
    pop bc      ;return
    pop hl      ;value
    pop de
    push de
    push hl
    push bc
    call asm_f24_i32
    jp asm_f16_f24

