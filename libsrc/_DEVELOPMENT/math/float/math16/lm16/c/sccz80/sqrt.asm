
    SECTION code_fp_math16
    PUBLIC sqrtf16
    EXTERN asm_f16_sqrt

    defc sqrtf16 = asm_f16_sqrt


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrtf16
EXTERN cm16_sdcc_sqrt
defc _sqrtf16 = cm16_sdcc_sqrt
ENDIF

