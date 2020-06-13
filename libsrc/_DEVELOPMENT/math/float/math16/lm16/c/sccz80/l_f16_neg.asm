
    SECTION code_fp_math16

    PUBLIC  l_f16_neg

    PUBLIC  f16_neg

    EXTERN  asm_f16_neg

    defc l_f16_neg = asm_f16_neg

    defc f16_neg = asm_f16_neg


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_neg
EXTERN cm16_sdcc_neg
defc _f16_neg = cm16_sdcc_neg
ENDIF

