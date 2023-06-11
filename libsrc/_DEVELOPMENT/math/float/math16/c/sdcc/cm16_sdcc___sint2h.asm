
SECTION code_fp_math16

PUBLIC cm16_sdcc___sint2h

EXTERN asm_f24_i16
EXTERN asm_f16_f24

.cm16_sdcc___sint2h
    pop    bc    ;return
    pop    hl    ;value
    push    hl
    push    bc
    call asm_f24_i16
    jp asm_f16_f24

