
    SECTION code_fp_math16

    PUBLIC  l_f16_fabs
    
    PUBLIC  f16_fabs

    EXTERN  asm_f16_fabs

    defc l_f16_fabs = asm_f16_fabs

    defc f16_fabs = asm_f16_fabs


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_fabs
EXTERN cm16_sdcc_fabs
defc _f16_fabs = cm16_sdcc_fabs
ENDIF

