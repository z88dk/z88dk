
    SECTION code_fp_math16
    PUBLIC f16_inv
    EXTERN asm_f16_inv

    defc f16_inv = asm_f16_inv


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_inv
EXTERN cm16_sdcc_inv
defc _f16_inv = cm16_sdcc_inv
ENDIF

