
    SECTION code_fp_math16

    PUBLIC  l_f16_invf

    PUBLIC  invf16

    EXTERN  asm_f16_inv

    defc l_f16_invf = asm_f16_inv

    defc invf16 = asm_f16_inv


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _invf16
defc _invf16 = invf16
ENDIF

