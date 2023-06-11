
    SECTION code_fp_math16
    PUBLIC invsqrtf16
    EXTERN asm_f16_invsqrt

    defc invsqrtf16 = asm_f16_invsqrt


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _invsqrtf16
defc _invsqrtf16 = invsqrtf16
ENDIF

