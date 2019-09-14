
    SECTION code_fp_math32
    PUBLIC  pow_callee
    EXTERN  cm32_sccz80_pow_callee

    defc    pow_callee = cm32_sccz80_pow_callee

IF __CLASSIC
    ; SDCC bridge for Classic
    PUBLIC  _pow_callee
    defc    _pow_callee = pow_callee
ENDIF
