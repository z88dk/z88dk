
    SECTION code_fp_math16

    PUBLIC  l_f16_neg

    PUBLIC  negf16

    EXTERN  asm_f16_neg

    defc l_f16_neg = asm_f16_neg

    defc negf16 = asm_f16_neg


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _negf16
defc _negf16 = negf16
ENDIF

