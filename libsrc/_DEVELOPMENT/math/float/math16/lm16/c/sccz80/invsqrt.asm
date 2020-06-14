
    SECTION code_fp_math16
    PUBLIC f16_invsqrt
    EXTERN asm_f16_invsqrt

    defc f16_invsqrt = asm_f16_invsqrt


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f16_invsqrt
EXTERN cm16_sdcc_invsqrt
defc _f16_invsqrt = cm16_sdcc_invsqrt
ENDIF

