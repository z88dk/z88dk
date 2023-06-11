
    SECTION code_fp_math16
    PUBLIC sqrtf16
    EXTERN asm_f16_sqrt

    defc sqrtf16 = asm_f16_sqrt


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrtf16
defc _sqrtf16 = sqrtf16
ENDIF

