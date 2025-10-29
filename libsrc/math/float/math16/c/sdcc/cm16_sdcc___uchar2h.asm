
SECTION code_fp_math16

PUBLIC cm16_sdcc___uchar2h

EXTERN asm_f24_u16
EXTERN asm_f16_f24

.cm16_sdcc___uchar2h
    pop bc      ;return
    pop hl      ;value
    push hl
    push bc
    ld h,0
    call asm_f24_u16
    jp asm_f16_f24

