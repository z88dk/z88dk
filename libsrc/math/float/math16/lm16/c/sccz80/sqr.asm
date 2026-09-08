    SECTION code_clib
    SECTION code_fp_math16
    PUBLIC sqrf16
    EXTERN asm_f16_sqr

    defc sqrf16 = asm_f16_sqr


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sqrf16
defc _sqrf16 = sqrf16
ENDIF
