
    SECTION code_fp_math16
    PUBLIC f16_sqrt
    EXTERN asm_f16_sqrt

    defc f16_sqrt = asm_f16_sqrt


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_sqrt
EXTERN cm16_sdcc_sqrt
defc _f16_sqrt = cm16_sdcc_sqrt
ENDIF

