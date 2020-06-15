
    SECTION code_fp_math16
    PUBLIC  mul2f16
    EXTERN  asm_f16_mul2

    defc mul2f16 = asm_f16_mul2


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _mul2f16
EXTERN cm16_sdcc_mul2
defc _mul2f16 = cm16_sdcc_mul2
ENDIF

